create table Game (
  name varchar(255) primary key,
  title varchar(255),
  subtitle varchar(255),
  bios boolean default false,

  -- from gamerankings.com
  publisher varchar(255),
  year integer,
  gameranking decimal,
  gameranking_reviews integer,

  -- from giantbomb
  giantbomb_id integer,
  giantbomb_image varchar(255),
  summary text
);

-- from no-intro
create table ROM (
  file_name varchar(255) primary key,
  size integer not null,
  md5 binary(16) not null,
  crc binary(4) not null,
  sha1 binary(20) not null,

  region varchar(255),
  console varchar(255) not null,
  game varchar(255) not null,
  nointro_name varchar(255) not null,

  foreign key (console) references Console(name),
  foreign key (game) references Game(title),
  foreign key (region) references Region(name)
);

create table Region (
  name varchar(255) primary key
);

create table Company (
  name varchar(255) primary key
);

create table Console (
  name varchar(255) primary key,
  company varchar(255) not null,
  nointro_name varchar(255) not null,
  foreign key (company) references Company(name)
);
