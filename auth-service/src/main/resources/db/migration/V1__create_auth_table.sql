CREATE TABLE users (
                       id UUID PRIMARY KEY,

                       email VARCHAR(255) NOT NULL,
                       password_hash VARCHAR(255) NOT NULL,

                       first_name VARCHAR(100) NOT NULL,
                       last_name VARCHAR(100) NOT NULL,

                       role VARCHAR(20) NOT NULL,
                       account_status VARCHAR(20) NOT NULL,

                       email_verified BOOLEAN NOT NULL DEFAULT FALSE,

                       last_login_at TIMESTAMPTZ,

                       created_at TIMESTAMPTZ NOT NULL,
                       updated_at TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX ux_users_email
    ON users(email);

CREATE INDEX idx_users_status
    ON users(account_status);

CREATE TABLE addresses (
                           id UUID PRIMARY KEY,

                           user_id UUID NOT NULL,

                           address_line_1 VARCHAR(255) NOT NULL,
                           address_line_2 VARCHAR(255),

                           city VARCHAR(100) NOT NULL,
                           state VARCHAR(100) NOT NULL,
                           country VARCHAR(100) NOT NULL,

                           postal_code VARCHAR(20) NOT NULL,

                           is_default BOOLEAN NOT NULL DEFAULT FALSE,

                           created_at TIMESTAMPTZ NOT NULL,

                           CONSTRAINT fk_addresses_user
                               FOREIGN KEY (user_id)
                                   REFERENCES users(id)
                                   ON DELETE CASCADE
);

CREATE INDEX idx_addresses_user
    ON addresses(user_id);

CREATE TABLE refresh_tokens (
                                id UUID PRIMARY KEY,

                                user_id UUID NOT NULL,

                                token VARCHAR(512) NOT NULL,

                                expires_at TIMESTAMPTZ NOT NULL,

                                revoked BOOLEAN NOT NULL DEFAULT FALSE,

                                created_at TIMESTAMPTZ NOT NULL,

                                CONSTRAINT fk_refresh_tokens_user
                                    FOREIGN KEY (user_id)
                                        REFERENCES users(id)
                                        ON DELETE CASCADE
);

CREATE INDEX idx_refresh_tokens_user
    ON refresh_tokens(user_id);

CREATE INDEX idx_refresh_tokens_expiry
    ON refresh_tokens(expires_at);