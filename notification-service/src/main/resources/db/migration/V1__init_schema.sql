
CREATE TABLE notifications (
                               id UUID PRIMARY KEY,

                               user_id UUID NOT NULL,

                               notification_type VARCHAR(30) NOT NULL,

                               destination VARCHAR(255) NOT NULL,

                               subject VARCHAR(255),

                               message TEXT NOT NULL,

                               status VARCHAR(30) NOT NULL,

                               created_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_notifications_user
    ON notifications(user_id);

CREATE INDEX idx_notifications_status
    ON notifications(status);

CREATE INDEX idx_notifications_created
    ON notifications(created_at DESC);