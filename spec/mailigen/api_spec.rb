# rspec spec/mailigen/api_spec.rb
describe Mailigen::Api do
  let(:mailigen) { valid_mailigen_obj }
  let(:invalid_mailigen) { invalid_mailigen_obj }

  describe "#initialize(api_key, secure=false)" do
    it "raises error if blank API key passed" do
      expect { Mailigen::Api.new("") }.to raise_error(Mailigen::NoApiKeyError)
    end
  end

  describe "#call(api_method, params={})" do
    subject(:post_to_mailigen) { mailigen.call(method, params) }

    let(:create_list_params) do
      {
        title: "testListRspec",
        options: {
          permission_reminder: "You have been subscribed to email notifications",
          notify_to: "foo@bar.com",
          subscription_notify: false
        }
      }
    end

    context "when using a verbose mailigen api comms object" do
      subject(:post_to_mailigen) { mailigen.call(:ping) }

      let(:mailigen) { verbose_mailigen_obj }

      before do
        WebMock.stub_request(:post, %r'mailigen').to_return(
          :status => 200, :body => mock_ping_response
        )

        allow(STDOUT).to receive(:puts).and_call_original
      end

      it "outputs POSTed uri and data and the response" do
        expect(STDOUT).to receive(:puts).with("About to post to Mailigen:")
        expect(STDOUT).to receive(:puts).with("url: https://api.mailigen.com/1.5/?output=json&method=ping")
        expect(STDOUT).to receive(:puts).with("params: {:apikey=>\"9f62d5e5629e3dbd898810463da3569d\"}")
        expect(STDOUT).to receive(:puts).with("Got response from Mailigen:")
        expect(STDOUT).to receive(:puts).with("Everything's Ok!")

        post_to_mailigen
      end
    end

    describe ":ping api_method" do
      subject(:post_to_mailigen) { mailigen.call(:ping) }

      context "invalid mailigen key" do
        subject(:post_to_mailigen) { invalid_mailigen.call(:ping) }

        before do
          allow(invalid_mailigen).to receive(:call).with(:ping).and_return(mock_ping_error_response)
        end

        it "returns error response" do
          expect(post_to_mailigen["code"]).to eq(104)
          expect(post_to_mailigen["error"]).to eq("Invalid Mailigen API Key: invalid_api_key")
        end
      end

      context "valid mailigen key" do
        before do
          allow(mailigen).to receive(:call).with(:ping).and_return(mock_ping_response)
        end

        it "returns OK" do
          expect(post_to_mailigen).to eq("Everything's Ok!")
        end
      end
    end

    describe ":listCreate api_method" do
      let(:method) { :listCreate }
      let(:params) { create_list_params }

      before do
        allow(mailigen).to receive(:call).and_return(mock_listCreate_response(create_list_params[:title]))
      end

      it "returns list id if creation went well" do
        expect(post_to_mailigen).to eq("3932054d")
      end
    end

    describe ":lists api_method" do
      subject(:post_to_mailigen) { mailigen.call(:lists) }

      before do
        allow(mailigen).to receive(:call).and_return(mock_lists_response(create_list_params[:title]))
      end

      it "returns lists named 'testListRspec'" do
        resp = post_to_mailigen

        selected_lists = resp.select { |list| list["name"] == "testListRspec" }
        expect(selected_lists.size).to eq(1)
      end
    end

    describe ":listMergeVars api_method" do
      let(:method) { :listMergeVars }
      let(:params) { {id: "some list id"} }

      before do
        allow(mailigen).to receive(:call).and_return(mock_listMergeVars_response)
      end

      it "returns an array with list fields" do
        expect(post_to_mailigen.size).to eq(3) # list has three fields
      end
    end

    describe ":listMergeVarAdd api_method" do
      let(:method) { :listMergeVarAdd }
      let(:params) { {id: "some list id", tag: "FOO", name: "FooName"} }


      before do
        allow(mailigen).to receive(:call).and_return(mock_listMergeVarAdd_response)
      end

      it "returns 'true' string if adding went well" do
        expect(post_to_mailigen).to eq("true")
      end
    end

    describe ":listBatchSubscribe api_method" do
      let(:method) { :listBatchSubscribe }

      let(:user_batch) do
        {
          "0" => {EMAIL: "foo@sample.com", EMAIL_TYPE: 'plain', NAME: 'Foo'},
          "1" => {EMAIL: "bar@sample.com", EMAIL_TYPE: 'html',  NAME: 'Bar'},
          "2" => {EMAIL: "foo@sample.com", EMAIL_TYPE: 'html',  NAME: 'Foo Dublicate'}
        }
      end

      let(:params) do
        {
          id: "some_id", batch: @user_batch,
          double_optin: false, update_existing: true
        }
      end

      before do
        allow(mailigen).to receive(:call).and_return(mock_listBatchSubscribe_response)
      end

      it "returns success count and fail count" do
        expect(post_to_mailigen["success_count"]).to eq(3)
        expect(post_to_mailigen["error_count"]).to eq(0)
      end
    end
  end

  describe "api_url" do
    context "secure" do
      it "return url" do
        obj = Mailigen::Api.new("fookey", true)
        expect(obj.api_url).to eq("https://api.mailigen.com/1.5/?output=json")
      end
    end

    context "default (insecure)" do
      it "return url" do
        expect(invalid_mailigen.api_url).to eq("http://api.mailigen.com/1.5/?output=json")
      end
    end

  end

end
