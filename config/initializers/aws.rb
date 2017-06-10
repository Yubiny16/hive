CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     '',                        # required
    aws_secret_access_key: '',                        # required
    region:                'us-east-1',                  # optional, defaults to 'us-east-1'
    endpoint:              'https://s3.amazonaws.com' # optional, defaults to nil
  }
  config.fog_directory  = 'hiveuserprofpic'                          # required
  config.fog_public     = true                                        # optional, defaults to true
  config.fog_attributes = {} # optional, defaults to {}
end
