CREATE TYPE role_enum AS ENUM ('customer', 'owner');
CREATE TYPE price_type AS ENUM ('per_unit', 'per_kg');
CREATE TYPE category_enum AS ENUM ('food', 'drink', 'vegetables', 'utility', 'other');
CREATE TYPE day_of_week_enum AS ENUM (
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(40) NOT NULL,
  surname VARCHAR(40) NOT NULL,
  birthdate DATE NOT NULL,
  email VARCHAR NOT NULL UNIQUE,
  password VARCHAR(60) NOT NULL,
  phone VARCHAR(20) NULL,
  role role_enum NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT age_check CHECK (EXTRACT(YEAR FROM age(CURRENT_DATE, birthdate)) >= 18)
);

CREATE TABLE stores (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(200) NOT NULL,
  open BOOLEAN NOT NULL DEFAULT FALSE,
  phone VARCHAR(20) NULL,
  lat NUMERIC(11, 8) NOT NULL,
  lng NUMERIC(11, 8) NOT NULL,
  owner_id INTEGER NOT NULL REFERENCES users(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE store_hours (
  store_id INTEGER NOT NULL REFERENCES stores(id),
  day_of_week day_of_week_enum NOT NULL,
  opening_time TIME NULL,
  closing_time TIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT check_valid_opening_hours CHECK (opening_time IS NULL AND closing_time IS NULL OR opening_time IS NOT NULL AND closing_time IS NOT NULL),
  CONSTRAINT check_pk_store_hours PRIMARY KEY (store_id, day_of_week)
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT NULL,
  has_image BOOLEAN NOT NULL DEFAULT FALSE,
  price INTEGER NOT NULL,
  price_type price_type NOT NULL,
  store_id INTEGER NOT NULL REFERENCES stores(id),
  stock SMALLINT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE products_categories (
  product_id INTEGER NOT NULL REFERENCES products(id),
  category category_enum NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT PK_products_categories PRIMARY KEY (product_id, category)
);