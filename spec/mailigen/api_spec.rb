# rspec spec/mailigen/api_spec.rb
describe Mailigen::Api do
  before(:all) do
    @invalid_mailigen = invalid_mailigen_obj
    @mailigen = valid_mailigen_obj
  end

  describe "#initialize(api_key, secure=false)" do
    it "should raise error if blank API key passed" do
      expect { Mailigen::Api.new("") }.to raise_error(Mailigen::NoApiKeyError)
    end
  end

  describe "#call(api_method, params={})" do
    before :all do
      @create_list_params = {
        title: "testListRspec",
        options: {
          permission_reminder: "You have been subscribed to email notifications",
          notify_to: "foo@bar.com",
          subscription_notify: false
        }
      }
    end

    describe ":ping api_method" do
      context "invalid mailigen key" do
        it "should return error response" do
          allow(@invalid_mailigen).to receive(:call).with(:ping).and_return(mock_ping_error_response)

          resp = @invalid_mailigen.call(:ping)

          expect(resp["code"]).to eq(104)
          expect(resp["error"]).to eq("Invalid Mailigen API Key: invalid_api_key")
        end
      end

      context "valid mailigen key" do
        it "returns OK" do
          allow(@mailigen).to receive(:call).with(:ping).and_return(mock_ping_response)
          resp = @mailigen.call(:ping)
          expect(resp).to eq("Everything's Ok!")
        end
      end
    end

    describe ":listCreate api_method" do
      it "should return list id if creation went well" do
        allow(@mailigen).to receive(:call).and_return(mock_listCreate_response(@create_list_params[:title]))

        resp = @mailigen.call(:listCreate, @create_list_params)

        expect(resp).to eq "3932054d"
      end
    end

    describe ":lists api_method" do
      it "should return lists named 'testListRspec'" do
        allow(@mailigen).to receive(:call).and_return(mock_lists_response(@create_list_params[:title]))

        resp = @mailigen.call(:lists)

        selected_lists = resp.select { |list| list["name"] == "testListRspec" }
        expect(selected_lists.size).to eq(1)
      end
    end

    describe ":listMergeVars api_method" do
      it "should return an array with list fields" do
        allow(@mailigen).to receive(:call).and_return(mock_listMergeVars_response)

        resp = @mailigen.call(:listMergeVars, {id: @list_id})

        expect(resp.size).to eq(3) # list has three fields
      end
    end

    describe ":listMergeVarAdd api_method" do
      it "should return 'true' sting is adding went well" do
        params = {id: @list_id, tag: "FOO", name: "FooName"}
        allow(@mailigen).to receive(:call).and_return(mock_listMergeVarAdd_response)

        resp = @mailigen.call(:listMergeVarAdd, params)

        expect(resp).to eq("true")
      end
    end

    describe ":listBatchSubscribe api_method" do
      it "returns success count and fail count" do
        @user_batch = {
          "0" => {EMAIL: "foo@sample.com", EMAIL_TYPE: 'plain', NAME: 'Foo'},
          "1" => {EMAIL: "bar@sample.com", EMAIL_TYPE: 'html',  NAME: 'Bar'},
          "2" => {EMAIL: "foo@sample.com", EMAIL_TYPE: 'html',  NAME: 'Foo Dublicate'}
        }

        params = {id: @list_id, batch: @user_batch, double_optin: false}

        allow(@mailigen).to receive(:call).and_return(mock_listBatchSubscribe_response)

        resp = @mailigen.call(:listBatchSubscribe, params)

        expect(resp["success_count"]).to eq(3)
        expect(resp["error_count"]).to eq(0)
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
        expect(@invalid_mailigen.api_url).to eq("http://api.mailigen.com/1.5/?output=json")
      end
    end

  end

end
