
-- Optimize city and date filtering
CREATE INDEX IF NOT EXISTS idx_hotel_bookings_city_created_at
ON hotel_bookings (city, created_at);

-- Optimize grouping and filtering by organization and status
CREATE INDEX IF NOT EXISTS idx_hotel_bookings_org_status
ON hotel_bookings (org_id, status);

-- Optimize booking event lookups by booking ID
CREATE INDEX IF NOT EXISTS idx_booking_events_booking_id
ON booking_events (booking_id);
