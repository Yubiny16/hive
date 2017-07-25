CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'AKIAI4VGDXYN6SRVPCJA',                        # required
    aws_secret_access_key: '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',                        # required
    region:                'us-east-1',                  # optional, defaults to 'us-east-1'
    endpoint:              'https://s3.amazonaws.com' # optional, defaults to nil
  }
  config.fog_directory  = 'hiveuserprofpic'                          # required
  config.fog_public     = true                                        # optional, defaults to true
  config.fog_attributes = {} # optional, defaults to {}
end
