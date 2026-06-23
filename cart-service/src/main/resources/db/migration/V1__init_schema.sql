CREATE TABLE carts (
                       id UUID PRIMARY KEY,

                       user_id UUID NOT NULL,

                       status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

                       expires_at TIMESTAMPTZ,

                       created_at TIMESTAMPTZ NOT NULL,
                       updated_at TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX ux_cart_user_active
    ON carts(user_id)
    WHERE status = 'ACTIVE';

CREATE INDEX idx_cart_updated_at
    ON carts(updated_at DESC);



CREATE TABLE cart_items (
                            id UUID PRIMARY KEY,

                            cart_id UUID NOT NULL,

                            product_id UUID NOT NULL,

                            sku VARCHAR(100) NOT NULL,

                            product_name VARCHAR(255) NOT NULL,

                            unit_price NUMERIC(12,2) NOT NULL,

                            quantity INTEGER NOT NULL CHECK(quantity > 0),

                            created_at TIMESTAMPTZ NOT NULL,

                            CONSTRAINT fk_cart_items_cart
                                FOREIGN KEY(cart_id)
                                    REFERENCES carts(id)
                                    ON DELETE CASCADE
);

CREATE UNIQUE INDEX ux_cart_item_product
    ON cart_items(cart_id, product_id);

CREATE INDEX idx_cart_items_cart
    ON cart_items(cart_id);

CREATE INDEX idx_cart_items_product
    ON cart_items(product_id);



CREATE TABLE outbox_events (
                               id UUID PRIMARY KEY,

                               aggregate_type VARCHAR(100) NOT NULL,

                               aggregate_id UUID NOT NULL,

                               event_type VARCHAR(100) NOT NULL,

                               payload JSONB NOT NULL,

                               processed BOOLEAN NOT NULL DEFAULT FALSE,

                               created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_cart_outbox_processed
    ON outbox_events(processed, created_at);