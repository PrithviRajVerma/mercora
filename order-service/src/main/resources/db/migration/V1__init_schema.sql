
CREATE TABLE orders (
                        id UUID PRIMARY KEY,

                        order_number VARCHAR(50) NOT NULL,

                        user_id UUID NOT NULL,

                        shipping_address_snapshot JSONB NOT NULL,

                        subtotal NUMERIC(12,2) NOT NULL,

                        shipping_fee NUMERIC(12,2) NOT NULL,

                        total_amount NUMERIC(12,2) NOT NULL,

                        status VARCHAR(30) NOT NULL,

                        created_at TIMESTAMPTZ NOT NULL,
                        updated_at TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX ux_orders_number
    ON orders(order_number);

CREATE INDEX idx_orders_user
    ON orders(user_id);

CREATE INDEX idx_orders_status
    ON orders(status);

CREATE INDEX idx_orders_created
    ON orders(created_at DESC);

CREATE TABLE order_items (
                             id UUID PRIMARY KEY,

                             order_id UUID NOT NULL,

                             product_id UUID NOT NULL,

                             sku VARCHAR(100) NOT NULL,

                             product_name VARCHAR(255) NOT NULL,

                             unit_price NUMERIC(12,2) NOT NULL,

                             quantity INTEGER NOT NULL,

                             total_price NUMERIC(12,2) NOT NULL,

                             CONSTRAINT fk_order_items_order
                                 FOREIGN KEY(order_id)
                                     REFERENCES orders(id)
                                     ON DELETE CASCADE
);

CREATE INDEX idx_order_items_order
    ON order_items(order_id);

CREATE TABLE outbox_events (
                               id UUID PRIMARY KEY,

                               aggregate_type VARCHAR(100) NOT NULL,

                               aggregate_id UUID NOT NULL,

                               event_type VARCHAR(100) NOT NULL,

                               payload JSONB NOT NULL,

                               processed BOOLEAN NOT NULL DEFAULT FALSE,

                               created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_order_outbox_processed
    ON outbox_events(processed, created_at);