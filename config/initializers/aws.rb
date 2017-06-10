CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAJJK3HBHWRXXF6Q6Q',                        # required
    aws_secret_access_key: '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',                        # required
    region:                'us-east-1',                  # optional, defaults to 'us-east-1'
    endpoint:              'https://s3.amazonaws.com' # optional, defaults to nil
  }
  config.fog_directory  = 'hiveuserprofpic'                          # required
  config.fog_public     = true                                        # optional, defaults to true
  config.fog_attributes = {} # optional, defaults to {}
end
