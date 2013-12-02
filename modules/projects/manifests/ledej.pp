class projects::ledej {
  include redis
  include postgresql
  include elasticsearch

  boxen::project { 'ledej':
    dotenv        => true,
    elasticsearch => true,
    postgresql    => true,
    redis         => true,
    python        => '2.7.5',
    source        => 'ledej/ledej-website'
  }
}