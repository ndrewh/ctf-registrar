Paperclip::Attachment.default_options.merge(
  {
    # storage / fog / s3
    storage: :fog,
    fog_credentials: {
      provider: 'AWS',
      aws_secret_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      path_style: true,
    },
    fog_directory: 'teams-2015.legitbs.net',

    # image format
    # see http://www.imagemagick.org/script/command-line-processing.php#geometry
    styles: {
      flake: '8x8#',
      thumb: '64x64#',
      badge: '160x120',
      medium: '256x256',
      large: '512x512'
    },

    # urls
    hash_secret: 'spewing torrents of bees from my mouth',
    hash_data: ":rails_env/:class/:attachment/:id/:style/:updated_at",
    url: 'https://teams-2015.legitbs.net/t/:hash.:extension',
    path: '/t/:hash.:extension',
  })