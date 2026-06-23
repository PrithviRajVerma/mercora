
CREATE TABLE payments (
                          id UUID PRIMARY KEY,

                          order_id UUID NOT NULL,

                          amount NUMERIC(12,2) NOT NULL,

                          provider VARCHAR(50) NOT NULL,

                          transaction_reference VARCHAR(255),

                          status VARCHAR(30) NOT NULL,

                          created_at TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX ux_transaction_reference
    ON payments(transaction_reference);

CREATE INDEX idx_payments_order
    ON payments(order_id);

CREATE INDEX idx_payments_status
    ON payments(status);

CREATE TABLE outbox_events (
                               id UUID PRIMARY KEY,

                               aggregate_type VARCHAR(100) NOT NULL,

                               aggregate_id UUID NOT NULL,

                               event_type VARCHAR(100) NOT NULL,

                               payload JSONB NOT NULL,

                               processed BOOLEAN NOT NULL DEFAULT FALSE,

                               created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_payment_outbox_processed
    ON outbox_events(processed, created_at);