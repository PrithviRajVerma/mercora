
CREATE TABLE categories (
                            id UUID PRIMARY KEY,

                            name VARCHAR(100) NOT NULL,
                            slug VARCHAR(100) NOT NULL,

                            description TEXT,

                            created_at TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX ux_categories_slug
    ON categories(slug);

CREATE UNIQUE INDEX ux_categories_name
    ON categories(name);

CREATE TABLE products (
                          id UUID PRIMARY KEY,

                          category_id UUID NOT NULL,

                          sku VARCHAR(100) NOT NULL,

                          name VARCHAR(255) NOT NULL,
                          slug VARCHAR(255) NOT NULL,

                          description TEXT,

                          price NUMERIC(12,2) NOT NULL,

                          active BOOLEAN NOT NULL DEFAULT TRUE,

                          deleted_at TIMESTAMPTZ,

                          created_at TIMESTAMPTZ NOT NULL,
                          updated_at TIMESTAMPTZ NOT NULL,

                          CONSTRAINT fk_products_category
                              FOREIGN KEY(category_id)
                                  REFERENCES categories(id)
                                  ON DELETE RESTRICT
);

CREATE UNIQUE INDEX ux_products_sku
    ON products(sku);

CREATE UNIQUE INDEX ux_products_slug
    ON products(slug);

CREATE INDEX idx_products_category
    ON products(category_id);

CREATE INDEX idx_products_active
    ON products(active)
    WHERE active = TRUE;

CREATE TABLE product_images (
                                id UUID PRIMARY KEY,

                                product_id UUID NOT NULL,

                                image_url TEXT NOT NULL,

                                sort_order INTEGER NOT NULL DEFAULT 0,

                                is_primary BOOLEAN NOT NULL DEFAULT FALSE,

                                CONSTRAINT fk_product_images_product
                                    FOREIGN KEY(product_id)
                                        REFERENCES products(id)
                                        ON DELETE CASCADE
);

CREATE INDEX idx_product_images_product
    ON product_images(product_id);

CREATE TABLE inventory (
                           product_id UUID PRIMARY KEY,

                           quantity INTEGER NOT NULL,

                           reserved_quantity INTEGER NOT NULL DEFAULT 0,

                           updated_at TIMESTAMPTZ NOT NULL,

                           CONSTRAINT fk_inventory_product
                               FOREIGN KEY(product_id)
                                   REFERENCES products(id)
                                   ON DELETE CASCADE
);

CREATE TABLE inventory_transactions (
                                        id UUID PRIMARY KEY,

                                        product_id UUID NOT NULL,

                                        quantity_change INTEGER NOT NULL,

                                        reason VARCHAR(50) NOT NULL,

                                        created_at TIMESTAMPTZ NOT NULL,

                                        CONSTRAINT fk_inventory_transactions_product
                                            FOREIGN KEY(product_id)
                                                REFERENCES products(id)
                                                ON DELETE CASCADE
);

CREATE INDEX idx_inventory_transactions_product
    ON inventory_transactions(product_id);

CREATE INDEX idx_inventory_transactions_created
    ON inventory_transactions(created_at DESC);

CREATE TABLE outbox_events (
                               id UUID PRIMARY KEY,

                               aggregate_type VARCHAR(100) NOT NULL,

                               aggregate_id UUID NOT NULL,

                               event_type VARCHAR(100) NOT NULL,

                               payload JSONB NOT NULL,

                               processed BOOLEAN NOT NULL DEFAULT FALSE,

                               created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_product_outbox_processed
    ON outbox_events(processed, created_at);