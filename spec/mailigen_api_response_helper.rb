# NB, responses gathered on 2017-01-24

def mock_ping_response
  return "Everything's Ok!"
end

def mock_ping_error_response
  return {"error"=>"Invalid Mailigen API Key: invalid_api_key", "code"=>104}
end

def mock_listCreate_response(list_name="test_list")
  return Digest::SHA256.hexdigest(list_name).first(8)
end

def mock_lists_response(needed_list_name)
  return [
    {
      "id"=>"194be8bf",
      "web_id"=>479143,
      "name"=>needed_list_name,
      "date_created"=>"2017-01-24 12:34:22",
      "member_count"=>0,
      "sms_member_count"=>0,
      "unsubscribe_count"=>0,
      "email_type_option"=>true,
      "default_from_name"=>"",
      "default_from_email"=>"foo@bar.com",
      "default_subject"=>"",
      "default_language"=>"en"
    },
    {
      "id"=>"63352788",
      "web_id"=>479133,
      "name"=>"Test list",
      "date_created"=>"2017-01-24 11:51:04",
      "member_count"=>1,
      "sms_member_count"=>1,
      "unsubscribe_count"=>0,
      "email_type_option"=>true,
      "default_from_name"=>"Augusts Bautra",
      "default_from_email"=>"augusts.bautra@gmail.com",
      "default_subject"=>"",
      "default_language"=>"en"
    },
  ]
end

# returns list's fields
def mock_listMergeVars_response
  return [
    {
      "name"=>"Email Address",
      "req"=>true,
      "field_type"=>"email",
      "show"=>true,
      "order"=>2,
      "default"=>"",
      "tag"=>"EMAIL",
      "predefined_values"=>"",
    },
    {
      "name"=>"First Name",
      "req"=>false,
      "field_type"=>"text",
      "show"=>true,
      "order"=>3,
      "default"=>"",
      "tag"=>"FNAME",
      "predefined_values"=>"",
    },
    {
      "name"=>"Last Name",
      "req"=>false,
      "field_type"=>"text",
      "show"=>true,
      "order"=>4,
      "default"=>"",
      "tag"=>"LNAME",
      "predefined_values"=>"",
    }
  ]
end

def mock_listMergeVarAdd_response
  return "true"
end

def mock_listBatchSubscribe_response
  return {"success_count"=>3, "error_count"=>0, "errors"=>[]}
end
