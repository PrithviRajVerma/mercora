
CREATE TABLE daily_sales (
                             sales_date DATE PRIMARY KEY,

                             total_orders BIGINT NOT NULL DEFAULT 0,

                             total_revenue NUMERIC(15,2) NOT NULL DEFAULT 0,

                             total_customers BIGINT NOT NULL DEFAULT 0,

                             average_order_value NUMERIC(15,2) NOT NULL DEFAULT 0,

                             created_at TIMESTAMPTZ NOT NULL,
                             updated_at TIMESTAMPTZ NOT NULL
);



CREATE TABLE product_sales (
                               product_id UUID PRIMARY KEY,

                               sku VARCHAR(100) NOT NULL,

                               product_name VARCHAR(255) NOT NULL,

                               units_sold BIGINT NOT NULL DEFAULT 0,

                               revenue NUMERIC(15,2) NOT NULL DEFAULT 0,

                               last_ordered_at TIMESTAMPTZ,

                               updated_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_product_sales_revenue
    ON product_sales(revenue DESC);

CREATE INDEX idx_product_sales_units
    ON product_sales(units_sold DESC);



CREATE TABLE user_metrics (
                              metric_date DATE PRIMARY KEY,

                              new_users BIGINT NOT NULL DEFAULT 0,

                              verified_users BIGINT NOT NULL DEFAULT 0,

                              active_users BIGINT NOT NULL DEFAULT 0,

                              created_at TIMESTAMPTZ NOT NULL,
                              updated_at TIMESTAMPTZ NOT NULL
);



CREATE TABLE order_metrics (
                               metric_date DATE PRIMARY KEY,

                               pending_orders BIGINT NOT NULL DEFAULT 0,

                               confirmed_orders BIGINT NOT NULL DEFAULT 0,

                               processing_orders BIGINT NOT NULL DEFAULT 0,

                               shipped_orders BIGINT NOT NULL DEFAULT 0,

                               delivered_orders BIGINT NOT NULL DEFAULT 0,

                               cancelled_orders BIGINT NOT NULL DEFAULT 0,

                               created_at TIMESTAMPTZ NOT NULL,
                               updated_at TIMESTAMPTZ NOT NULL
);



CREATE TABLE payment_metrics (
                                 metric_date DATE PRIMARY KEY,

                                 successful_payments BIGINT NOT NULL DEFAULT 0,

                                 failed_payments BIGINT NOT NULL DEFAULT 0,

                                 refunded_payments BIGINT NOT NULL DEFAULT 0,

                                 total_payment_volume NUMERIC(15,2) NOT NULL DEFAULT 0,

                                 created_at TIMESTAMPTZ NOT NULL,
                                 updated_at TIMESTAMPTZ NOT NULL
);



CREATE TABLE inventory_metrics (
                                   product_id UUID PRIMARY KEY,

                                   sku VARCHAR(100) NOT NULL,

                                   product_name VARCHAR(255) NOT NULL,

                                   available_quantity INTEGER NOT NULL,

                                   reserved_quantity INTEGER NOT NULL,

                                   last_updated_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_inventory_metrics_available
    ON inventory_metrics(available_quantity);



CREATE TABLE notification_metrics (
                                      metric_date DATE PRIMARY KEY,

                                      total_sent BIGINT NOT NULL DEFAULT 0,

                                      total_failed BIGINT NOT NULL DEFAULT 0,

                                      email_sent BIGINT NOT NULL DEFAULT 0,

                                      sms_sent BIGINT NOT NULL DEFAULT 0,

                                      push_sent BIGINT NOT NULL DEFAULT 0,

                                      created_at TIMESTAMPTZ NOT NULL,
                                      updated_at TIMESTAMPTZ NOT NULL
);



CREATE TABLE analytics_events (
                                  id UUID PRIMARY KEY,

                                  event_type VARCHAR(100) NOT NULL,

                                  aggregate_id UUID,

                                  payload JSONB NOT NULL,

                                  processed_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_analytics_events_type
    ON analytics_events(event_type);

CREATE INDEX idx_analytics_events_processed
    ON analytics_events(processed_at DESC);