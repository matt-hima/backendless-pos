/// SuiteCRM 7-compatible extension schema for universal membership workflows.
///
/// SuiteCRM core modules use string UUIDs, audit timestamps, assigned users,
/// and a deleted flag. Domain-specific records are represented as custom
/// modules with the same conventions and explicit relationship tables.
const suiteCrmSchema = r'''
CREATE SCHEMA IF NOT EXISTS suitecrm;

CREATE TABLE IF NOT EXISTS suitecrm.accounts (
  id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL,
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  assigned_user_id VARCHAR, description VARCHAR,
  deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.contacts (
  id VARCHAR PRIMARY KEY, account_id VARCHAR, first_name VARCHAR,
  last_name VARCHAR, email VARCHAR, phone VARCHAR,
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  assigned_user_id VARCHAR, deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.meetings (
  id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL, date_start TIMESTAMP NOT NULL,
  date_end TIMESTAMP NOT NULL, status VARCHAR DEFAULT 'Planned',
  parent_type VARCHAR, parent_id VARCHAR, description VARCHAR,
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.meetings_contacts (
  id VARCHAR PRIMARY KEY, meeting_id VARCHAR NOT NULL, contact_id VARCHAR NOT NULL,
  required VARCHAR DEFAULT '1', accept_status VARCHAR DEFAULT 'none',
  deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.aos_products (
  id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL, part_number VARCHAR,
  price DOUBLE DEFAULT 0, description VARCHAR, type VARCHAR DEFAULT 'Service',
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.aos_products_quotes (
  id VARCHAR PRIMARY KEY, parent_id VARCHAR NOT NULL, parent_type VARCHAR NOT NULL,
  product_id VARCHAR, quantity DOUBLE DEFAULT 1, product_list_price DOUBLE DEFAULT 0,
  product_unit_price DOUBLE DEFAULT 0, product_total_price DOUBLE DEFAULT 0,
  deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.memberships (
  id VARCHAR PRIMARY KEY, account_id VARCHAR NOT NULL, contact_id VARCHAR,
  membership_number VARCHAR NOT NULL UNIQUE, tier VARCHAR DEFAULT 'standard',
  points_balance INTEGER DEFAULT 0, lifetime_points INTEGER DEFAULT 0,
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.bookings (
  id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL, account_id VARCHAR,
  contact_id VARCHAR, resource_id VARCHAR, meeting_id VARCHAR,
  check_in TIMESTAMP NOT NULL, check_out TIMESTAMP NOT NULL,
  status VARCHAR DEFAULT 'Planned', amount DOUBLE DEFAULT 0,
  points_awarded INTEGER DEFAULT 0,
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.points_ledger (
  id VARCHAR PRIMARY KEY, membership_id VARCHAR NOT NULL, booking_id VARCHAR,
  reward_claim_id VARCHAR, points INTEGER NOT NULL, transaction_type VARCHAR NOT NULL,
  description VARCHAR, date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.rewards (
  id VARCHAR PRIMARY KEY, name VARCHAR NOT NULL, description VARCHAR,
  points_cost INTEGER NOT NULL, active BOOLEAN DEFAULT true,
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, deleted BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS suitecrm.reward_claims (
  id VARCHAR PRIMARY KEY, membership_id VARCHAR NOT NULL, reward_id VARCHAR NOT NULL,
  booking_id VARCHAR, points_spent INTEGER NOT NULL, status VARCHAR DEFAULT 'Claimed',
  claimed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, deleted BOOLEAN DEFAULT false
);
''';
