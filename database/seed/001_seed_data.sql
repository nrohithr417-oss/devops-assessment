
-- Generate 120 sample hotel bookings
INSERT INTO hotel_bookings (
    id, org_id, hotel_id, city,
    checkin_date, checkout_date, amount,
    status, created_at
)
SELECT
    gen_random_uuid(),
    ('00000000-0000-0000-0000-' ||
        LPAD((1 + (g % 5))::TEXT, 12, '0'))::UUID,
    'HOTEL-' || (1 + (g % 10)),
    (ARRAY['delhi', 'mumbai', 'hyderabad', 'chennai', 'bangalore'])[(g % 5) + 1],
    CURRENT_DATE + (g % 30),
    CURRENT_DATE + (g % 30) + 2,
    (2000 + (g * 150))::NUMERIC(12,2),
    (ARRAY['confirmed', 'pending', 'cancelled', 'completed'])[(g % 4) + 1],
    NOW() - (g || ' days')::INTERVAL
FROM generate_series(1, 120) AS g;

-- Generate booking events for the first 80 bookings
INSERT INTO booking_events (
    booking_id, event_type, payload, created_at
)
SELECT
    id,
    'booking_' || status,
    jsonb_build_object(
        'city', city,
        'amount', amount,
        'status', status
    ),
    created_at
FROM hotel_bookings
ORDER BY created_at DESC
LIMIT 80;
