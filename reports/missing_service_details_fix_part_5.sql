-- Auto-generated SQL to insert minimal missing service-detail rows
-- Review carefully before running. This script uses re_created_at as a fallback datetime where explicit service dates are absent.
-- Run in a transaction and/or on a replica for verification.

BEGIN;

-- reservation_car_sht for reservation 878cb4b8-e4c4-4d4b-a3b4-fd548269f404
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '878cb4b8-e4c4-4d4b-a3b4-fd548269f404', '2025-08-15T13:09:52.338+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '878cb4b8-e4c4-4d4b-a3b4-fd548269f404');

-- reservation_car_sht for reservation 73041c4d-e3db-4976-b2f2-05cb89d9b063
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '73041c4d-e3db-4976-b2f2-05cb89d9b063', '2025-08-15T13:09:52.268+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '73041c4d-e3db-4976-b2f2-05cb89d9b063');

-- reservation_car_sht for reservation 4897d40e-7339-46ff-aae9-f8da49e430cd
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4897d40e-7339-46ff-aae9-f8da49e430cd', '2025-08-15T13:09:52.201+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4897d40e-7339-46ff-aae9-f8da49e430cd');

-- reservation_car_sht for reservation e91605b5-4b56-4182-a341-6b9773888e51
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e91605b5-4b56-4182-a341-6b9773888e51', '2025-08-15T13:09:52.132+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e91605b5-4b56-4182-a341-6b9773888e51');

-- reservation_car_sht for reservation f9798611-9a09-4677-8810-d109ab8495e7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f9798611-9a09-4677-8810-d109ab8495e7', '2025-08-15T13:09:52.022+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f9798611-9a09-4677-8810-d109ab8495e7');

-- reservation_car_sht for reservation 4979576f-d91c-4383-8a86-4660e52cf8be
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4979576f-d91c-4383-8a86-4660e52cf8be', '2025-08-15T13:09:51.907+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4979576f-d91c-4383-8a86-4660e52cf8be');

-- reservation_car_sht for reservation c682cb62-d613-4aeb-9248-5288ea353278
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c682cb62-d613-4aeb-9248-5288ea353278', '2025-08-15T13:09:51.801+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c682cb62-d613-4aeb-9248-5288ea353278');

-- reservation_car_sht for reservation 2a9a9329-915e-4717-9300-b7a940803c2f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '2a9a9329-915e-4717-9300-b7a940803c2f', '2025-08-15T13:09:51.686+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '2a9a9329-915e-4717-9300-b7a940803c2f');

-- reservation_car_sht for reservation 342757b9-d091-4a6f-97a9-778d2eee6572
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '342757b9-d091-4a6f-97a9-778d2eee6572', '2025-08-15T13:09:51.599+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '342757b9-d091-4a6f-97a9-778d2eee6572');

-- reservation_car_sht for reservation 2ab0589a-c9f5-47c8-a1c2-6756828dd5f5
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '2ab0589a-c9f5-47c8-a1c2-6756828dd5f5', '2025-08-15T13:09:51.522+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '2ab0589a-c9f5-47c8-a1c2-6756828dd5f5');

-- reservation_car_sht for reservation 6834e646-7c2a-4c0f-b186-cb218c63c877
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6834e646-7c2a-4c0f-b186-cb218c63c877', '2025-08-15T13:09:51.421+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6834e646-7c2a-4c0f-b186-cb218c63c877');

-- reservation_car_sht for reservation 45bea044-9858-4c2f-b0c0-87f3420eb332
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '45bea044-9858-4c2f-b0c0-87f3420eb332', '2025-08-15T13:09:51.315+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '45bea044-9858-4c2f-b0c0-87f3420eb332');

-- reservation_car_sht for reservation c938154a-442c-4a7b-9562-8521e4f6ecce
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c938154a-442c-4a7b-9562-8521e4f6ecce', '2025-08-15T13:09:51.176+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c938154a-442c-4a7b-9562-8521e4f6ecce');

-- reservation_car_sht for reservation 6c3aa3d6-f848-4b62-aaba-8074593d6be7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6c3aa3d6-f848-4b62-aaba-8074593d6be7', '2025-08-15T13:09:51.084+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6c3aa3d6-f848-4b62-aaba-8074593d6be7');

-- reservation_car_sht for reservation 9590eab8-e3f4-44a6-9f68-a6a0bd76bef4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9590eab8-e3f4-44a6-9f68-a6a0bd76bef4', '2025-08-15T13:09:51+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9590eab8-e3f4-44a6-9f68-a6a0bd76bef4');

-- reservation_car_sht for reservation e7403eb2-e7e2-48aa-98dc-ddd42dba7e91
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e7403eb2-e7e2-48aa-98dc-ddd42dba7e91', '2025-08-15T13:09:50.906+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e7403eb2-e7e2-48aa-98dc-ddd42dba7e91');

-- reservation_car_sht for reservation 60976b49-1ae5-42e5-815d-dca2cf8ae5b8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '60976b49-1ae5-42e5-815d-dca2cf8ae5b8', '2025-08-15T13:09:50.8+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '60976b49-1ae5-42e5-815d-dca2cf8ae5b8');

-- reservation_car_sht for reservation 7a5ae78a-529b-4734-8a3e-cc7e2f60fe54
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7a5ae78a-529b-4734-8a3e-cc7e2f60fe54', '2025-08-15T13:09:50.712+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7a5ae78a-529b-4734-8a3e-cc7e2f60fe54');

-- reservation_car_sht for reservation 6f70c1a6-a8d5-4c6d-b631-360a614876f1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6f70c1a6-a8d5-4c6d-b631-360a614876f1', '2025-08-15T13:09:50.622+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6f70c1a6-a8d5-4c6d-b631-360a614876f1');

-- reservation_car_sht for reservation e741b39a-ab81-4da3-bee0-5d26f2a9d123
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e741b39a-ab81-4da3-bee0-5d26f2a9d123', '2025-08-15T13:09:50.517+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e741b39a-ab81-4da3-bee0-5d26f2a9d123');

-- reservation_car_sht for reservation 6a38d9c2-913f-4e80-a2c9-d1f4ef133a2a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6a38d9c2-913f-4e80-a2c9-d1f4ef133a2a', '2025-08-15T13:09:50.43+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6a38d9c2-913f-4e80-a2c9-d1f4ef133a2a');

-- reservation_car_sht for reservation 8ae5d6e8-bebe-45c0-98d6-e4e227dac733
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8ae5d6e8-bebe-45c0-98d6-e4e227dac733', '2025-08-15T13:09:50.331+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8ae5d6e8-bebe-45c0-98d6-e4e227dac733');

-- ensure reservation for bc99618d-1a71-40c1-9b1c-0c3f474c4174
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'bc99618d-1a71-40c1-9b1c-0c3f474c4174', '6a312c50-a017-44cc-a622-6731032e1508', '33b20ae9-dc9a-4b80-a838-2d51786a10bf', 'car', 'confirmed', '2025-08-14T07:15:48.845831+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'bc99618d-1a71-40c1-9b1c-0c3f474c4174');
UPDATE reservation SET re_quote_id = '33b20ae9-dc9a-4b80-a838-2d51786a10bf', re_type = 'car'
WHERE re_id = 'bc99618d-1a71-40c1-9b1c-0c3f474c4174' AND (re_quote_id IS DISTINCT FROM '33b20ae9-dc9a-4b80-a838-2d51786a10bf' OR re_type <> 'car');
-- reservation_cruise_car for reservation bc99618d-1a71-40c1-9b1c-0c3f474c4174
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'bc99618d-1a71-40c1-9b1c-0c3f474c4174', '2025-08-14T07:15:48.845831+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'bc99618d-1a71-40c1-9b1c-0c3f474c4174');

-- ensure reservation for 0a2d90fd-beaa-4ae6-b32c-f7ca526e1135
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0a2d90fd-beaa-4ae6-b32c-f7ca526e1135', 'eab1701e-1794-44b0-9d14-ac898de8b828', '8eaeca6f-e12f-4363-b2a7-df5d6950039c', 'car', 'confirmed', '2025-08-14T07:15:48.217969+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0a2d90fd-beaa-4ae6-b32c-f7ca526e1135');
UPDATE reservation SET re_quote_id = '8eaeca6f-e12f-4363-b2a7-df5d6950039c', re_type = 'car'
WHERE re_id = '0a2d90fd-beaa-4ae6-b32c-f7ca526e1135' AND (re_quote_id IS DISTINCT FROM '8eaeca6f-e12f-4363-b2a7-df5d6950039c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0a2d90fd-beaa-4ae6-b32c-f7ca526e1135
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0a2d90fd-beaa-4ae6-b32c-f7ca526e1135', '2025-08-14T07:15:48.217969+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0a2d90fd-beaa-4ae6-b32c-f7ca526e1135');

-- ensure reservation for 3d9fedcf-9d08-4623-bcdc-68b92d0ff9d6
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3d9fedcf-9d08-4623-bcdc-68b92d0ff9d6', 'd6f55182-9504-49df-9333-3d5c2cc16fd0', '7569910d-5358-4b9f-8a0a-a459d09fb3c3', 'car', 'confirmed', '2025-08-14T07:15:47.64647+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3d9fedcf-9d08-4623-bcdc-68b92d0ff9d6');
UPDATE reservation SET re_quote_id = '7569910d-5358-4b9f-8a0a-a459d09fb3c3', re_type = 'car'
WHERE re_id = '3d9fedcf-9d08-4623-bcdc-68b92d0ff9d6' AND (re_quote_id IS DISTINCT FROM '7569910d-5358-4b9f-8a0a-a459d09fb3c3' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3d9fedcf-9d08-4623-bcdc-68b92d0ff9d6
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3d9fedcf-9d08-4623-bcdc-68b92d0ff9d6', '2025-08-14T07:15:47.64647+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3d9fedcf-9d08-4623-bcdc-68b92d0ff9d6');

-- ensure reservation for 3ea7bf0f-37c9-48de-b196-5a8541d32b54
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3ea7bf0f-37c9-48de-b196-5a8541d32b54', 'fcc1b070-cdf6-4ed9-8a3f-1f73d3ea841c', 'a53bde3e-ebd1-42a9-b220-22f26e4351e7', 'car', 'confirmed', '2025-08-14T07:15:47.034061+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3ea7bf0f-37c9-48de-b196-5a8541d32b54');
UPDATE reservation SET re_quote_id = 'a53bde3e-ebd1-42a9-b220-22f26e4351e7', re_type = 'car'
WHERE re_id = '3ea7bf0f-37c9-48de-b196-5a8541d32b54' AND (re_quote_id IS DISTINCT FROM 'a53bde3e-ebd1-42a9-b220-22f26e4351e7' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3ea7bf0f-37c9-48de-b196-5a8541d32b54
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3ea7bf0f-37c9-48de-b196-5a8541d32b54', '2025-08-14T07:15:47.034061+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3ea7bf0f-37c9-48de-b196-5a8541d32b54');

-- ensure reservation for af18b923-f7cf-4961-b3dc-e8e3d84b7b79
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'af18b923-f7cf-4961-b3dc-e8e3d84b7b79', 'fcc1b070-cdf6-4ed9-8a3f-1f73d3ea841c', 'a53bde3e-ebd1-42a9-b220-22f26e4351e7', 'car', 'confirmed', '2025-08-14T07:15:46.425999+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'af18b923-f7cf-4961-b3dc-e8e3d84b7b79');
UPDATE reservation SET re_quote_id = 'a53bde3e-ebd1-42a9-b220-22f26e4351e7', re_type = 'car'
WHERE re_id = 'af18b923-f7cf-4961-b3dc-e8e3d84b7b79' AND (re_quote_id IS DISTINCT FROM 'a53bde3e-ebd1-42a9-b220-22f26e4351e7' OR re_type <> 'car');
-- reservation_cruise_car for reservation af18b923-f7cf-4961-b3dc-e8e3d84b7b79
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'af18b923-f7cf-4961-b3dc-e8e3d84b7b79', '2025-08-14T07:15:46.425999+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'af18b923-f7cf-4961-b3dc-e8e3d84b7b79');

-- ensure reservation for c502cded-ed0b-42cd-acf1-78721387c1a1
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c502cded-ed0b-42cd-acf1-78721387c1a1', 'f712525c-d5a0-4159-8dfe-43f8a8a579fa', '4c95b92b-22e3-4eef-801f-1cae3bc6b97a', 'car', 'confirmed', '2025-08-14T07:15:39.692123+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c502cded-ed0b-42cd-acf1-78721387c1a1');
UPDATE reservation SET re_quote_id = '4c95b92b-22e3-4eef-801f-1cae3bc6b97a', re_type = 'car'
WHERE re_id = 'c502cded-ed0b-42cd-acf1-78721387c1a1' AND (re_quote_id IS DISTINCT FROM '4c95b92b-22e3-4eef-801f-1cae3bc6b97a' OR re_type <> 'car');
-- reservation_cruise_car for reservation c502cded-ed0b-42cd-acf1-78721387c1a1
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c502cded-ed0b-42cd-acf1-78721387c1a1', '2025-08-14T07:15:39.692123+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c502cded-ed0b-42cd-acf1-78721387c1a1');

-- ensure reservation for 7591659c-487f-4170-ad54-bf245b4f523a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '7591659c-487f-4170-ad54-bf245b4f523a', '0dc2c70d-289b-44b2-83bb-4ae18bd906f6', '53c30c5d-0032-4f5d-968e-9467b173445c', 'car', 'confirmed', '2025-08-14T07:15:36.492715+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '7591659c-487f-4170-ad54-bf245b4f523a');
UPDATE reservation SET re_quote_id = '53c30c5d-0032-4f5d-968e-9467b173445c', re_type = 'car'
WHERE re_id = '7591659c-487f-4170-ad54-bf245b4f523a' AND (re_quote_id IS DISTINCT FROM '53c30c5d-0032-4f5d-968e-9467b173445c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 7591659c-487f-4170-ad54-bf245b4f523a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '7591659c-487f-4170-ad54-bf245b4f523a', '2025-08-14T07:15:36.492715+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '7591659c-487f-4170-ad54-bf245b4f523a');

-- ensure reservation for 30aea5b3-70bf-4a08-a456-53a329bcfc76
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '30aea5b3-70bf-4a08-a456-53a329bcfc76', 'f044d5bb-79c1-4283-ba9f-23baa1dd9684', 'fa56bbea-992b-4bfa-b337-13fc7977a349', 'car', 'confirmed', '2025-08-14T07:15:34.63952+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '30aea5b3-70bf-4a08-a456-53a329bcfc76');
UPDATE reservation SET re_quote_id = 'fa56bbea-992b-4bfa-b337-13fc7977a349', re_type = 'car'
WHERE re_id = '30aea5b3-70bf-4a08-a456-53a329bcfc76' AND (re_quote_id IS DISTINCT FROM 'fa56bbea-992b-4bfa-b337-13fc7977a349' OR re_type <> 'car');
-- reservation_cruise_car for reservation 30aea5b3-70bf-4a08-a456-53a329bcfc76
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '30aea5b3-70bf-4a08-a456-53a329bcfc76', '2025-08-14T07:15:34.63952+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '30aea5b3-70bf-4a08-a456-53a329bcfc76');

-- ensure reservation for 0a9bf72c-c664-410b-b523-dccca0c3ef4a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0a9bf72c-c664-410b-b523-dccca0c3ef4a', 'd9ced91b-d4b3-40df-ae9b-001546b3cb9a', '7b90f612-5d44-4998-8e15-6ad64e256e15', 'car', 'confirmed', '2025-08-14T07:15:34.05249+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0a9bf72c-c664-410b-b523-dccca0c3ef4a');
UPDATE reservation SET re_quote_id = '7b90f612-5d44-4998-8e15-6ad64e256e15', re_type = 'car'
WHERE re_id = '0a9bf72c-c664-410b-b523-dccca0c3ef4a' AND (re_quote_id IS DISTINCT FROM '7b90f612-5d44-4998-8e15-6ad64e256e15' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0a9bf72c-c664-410b-b523-dccca0c3ef4a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0a9bf72c-c664-410b-b523-dccca0c3ef4a', '2025-08-14T07:15:34.05249+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0a9bf72c-c664-410b-b523-dccca0c3ef4a');

-- ensure reservation for 62eebcf5-bc6d-4688-9664-d8acf2b20c0c
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '62eebcf5-bc6d-4688-9664-d8acf2b20c0c', '0957e52b-52fa-4d27-aa7d-68201b81498f', '56544ed4-6d41-469e-b4c8-a01e86444f9e', 'car', 'confirmed', '2025-08-14T07:15:31.647149+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '62eebcf5-bc6d-4688-9664-d8acf2b20c0c');
UPDATE reservation SET re_quote_id = '56544ed4-6d41-469e-b4c8-a01e86444f9e', re_type = 'car'
WHERE re_id = '62eebcf5-bc6d-4688-9664-d8acf2b20c0c' AND (re_quote_id IS DISTINCT FROM '56544ed4-6d41-469e-b4c8-a01e86444f9e' OR re_type <> 'car');
-- reservation_cruise_car for reservation 62eebcf5-bc6d-4688-9664-d8acf2b20c0c
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '62eebcf5-bc6d-4688-9664-d8acf2b20c0c', '2025-08-14T07:15:31.647149+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '62eebcf5-bc6d-4688-9664-d8acf2b20c0c');

-- ensure reservation for e8443a0b-a3f1-43c3-8193-7085ce95b414
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e8443a0b-a3f1-43c3-8193-7085ce95b414', '3afd75a7-daef-4678-a723-54814740e374', 'cb21ea41-9480-487d-806f-8d92e50a7bbc', 'car', 'confirmed', '2025-08-14T07:15:28.237317+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e8443a0b-a3f1-43c3-8193-7085ce95b414');
UPDATE reservation SET re_quote_id = 'cb21ea41-9480-487d-806f-8d92e50a7bbc', re_type = 'car'
WHERE re_id = 'e8443a0b-a3f1-43c3-8193-7085ce95b414' AND (re_quote_id IS DISTINCT FROM 'cb21ea41-9480-487d-806f-8d92e50a7bbc' OR re_type <> 'car');
-- reservation_cruise_car for reservation e8443a0b-a3f1-43c3-8193-7085ce95b414
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e8443a0b-a3f1-43c3-8193-7085ce95b414', '2025-08-14T07:15:28.237317+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e8443a0b-a3f1-43c3-8193-7085ce95b414');

-- ensure reservation for 43c57f8e-6941-458f-8070-657be4351062
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '43c57f8e-6941-458f-8070-657be4351062', 'e0237623-b66d-4b53-8018-2d17ed66ce7e', '81bcbcff-4366-4619-9eec-eda1ecd49e21', 'car', 'confirmed', '2025-08-14T07:15:27.633174+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '43c57f8e-6941-458f-8070-657be4351062');
UPDATE reservation SET re_quote_id = '81bcbcff-4366-4619-9eec-eda1ecd49e21', re_type = 'car'
WHERE re_id = '43c57f8e-6941-458f-8070-657be4351062' AND (re_quote_id IS DISTINCT FROM '81bcbcff-4366-4619-9eec-eda1ecd49e21' OR re_type <> 'car');
-- reservation_cruise_car for reservation 43c57f8e-6941-458f-8070-657be4351062
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '43c57f8e-6941-458f-8070-657be4351062', '2025-08-14T07:15:27.633174+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '43c57f8e-6941-458f-8070-657be4351062');

-- ensure reservation for eac7ebb4-28e0-4947-b2ae-2c2163a21b8b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'eac7ebb4-28e0-4947-b2ae-2c2163a21b8b', '3afd75a7-daef-4678-a723-54814740e374', 'cb21ea41-9480-487d-806f-8d92e50a7bbc', 'car', 'confirmed', '2025-08-14T07:15:27.068091+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'eac7ebb4-28e0-4947-b2ae-2c2163a21b8b');
UPDATE reservation SET re_quote_id = 'cb21ea41-9480-487d-806f-8d92e50a7bbc', re_type = 'car'
WHERE re_id = 'eac7ebb4-28e0-4947-b2ae-2c2163a21b8b' AND (re_quote_id IS DISTINCT FROM 'cb21ea41-9480-487d-806f-8d92e50a7bbc' OR re_type <> 'car');
-- reservation_cruise_car for reservation eac7ebb4-28e0-4947-b2ae-2c2163a21b8b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'eac7ebb4-28e0-4947-b2ae-2c2163a21b8b', '2025-08-14T07:15:27.068091+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'eac7ebb4-28e0-4947-b2ae-2c2163a21b8b');

-- ensure reservation for 832f8c24-2362-4e5a-9c87-8066977d616a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '832f8c24-2362-4e5a-9c87-8066977d616a', 'bc140154-b991-4b5a-a815-9dcec9cfa8bc', 'ba7dbcba-5965-4a57-ac29-34f9aa1cdb8f', 'car', 'confirmed', '2025-08-14T07:15:23.869776+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '832f8c24-2362-4e5a-9c87-8066977d616a');
UPDATE reservation SET re_quote_id = 'ba7dbcba-5965-4a57-ac29-34f9aa1cdb8f', re_type = 'car'
WHERE re_id = '832f8c24-2362-4e5a-9c87-8066977d616a' AND (re_quote_id IS DISTINCT FROM 'ba7dbcba-5965-4a57-ac29-34f9aa1cdb8f' OR re_type <> 'car');
-- reservation_cruise_car for reservation 832f8c24-2362-4e5a-9c87-8066977d616a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '832f8c24-2362-4e5a-9c87-8066977d616a', '2025-08-14T07:15:23.869776+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '832f8c24-2362-4e5a-9c87-8066977d616a');

-- ensure reservation for 8c31b276-1d02-490a-a63e-01a64205a182
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '8c31b276-1d02-490a-a63e-01a64205a182', 'd9deca71-c41d-4cb0-952d-7ee69f4b189f', '899f661e-8745-42c4-ba65-2a1cf28a1e80', 'car', 'confirmed', '2025-08-14T07:15:23.297204+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '8c31b276-1d02-490a-a63e-01a64205a182');
UPDATE reservation SET re_quote_id = '899f661e-8745-42c4-ba65-2a1cf28a1e80', re_type = 'car'
WHERE re_id = '8c31b276-1d02-490a-a63e-01a64205a182' AND (re_quote_id IS DISTINCT FROM '899f661e-8745-42c4-ba65-2a1cf28a1e80' OR re_type <> 'car');
-- reservation_cruise_car for reservation 8c31b276-1d02-490a-a63e-01a64205a182
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '8c31b276-1d02-490a-a63e-01a64205a182', '2025-08-14T07:15:23.297204+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '8c31b276-1d02-490a-a63e-01a64205a182');

-- ensure reservation for 676e66b0-19af-4def-914c-9c017e92b3c2
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '676e66b0-19af-4def-914c-9c017e92b3c2', 'dc7f9f61-382c-45cd-8e58-44a6407feadb', '356bde34-9e37-44a3-abf2-dd327c873734', 'car', 'confirmed', '2025-08-14T07:15:22.705215+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '676e66b0-19af-4def-914c-9c017e92b3c2');
UPDATE reservation SET re_quote_id = '356bde34-9e37-44a3-abf2-dd327c873734', re_type = 'car'
WHERE re_id = '676e66b0-19af-4def-914c-9c017e92b3c2' AND (re_quote_id IS DISTINCT FROM '356bde34-9e37-44a3-abf2-dd327c873734' OR re_type <> 'car');
-- reservation_cruise_car for reservation 676e66b0-19af-4def-914c-9c017e92b3c2
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '676e66b0-19af-4def-914c-9c017e92b3c2', '2025-08-14T07:15:22.705215+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '676e66b0-19af-4def-914c-9c017e92b3c2');

-- ensure reservation for 1991404f-306a-497c-8ba6-711ab54a3a51
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1991404f-306a-497c-8ba6-711ab54a3a51', '6e1f3040-20a4-44ae-b0b7-2f290e4f1c55', '814a6d72-44c7-4210-b4ed-6df999324198', 'car', 'confirmed', '2025-08-14T07:15:20.455802+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1991404f-306a-497c-8ba6-711ab54a3a51');
UPDATE reservation SET re_quote_id = '814a6d72-44c7-4210-b4ed-6df999324198', re_type = 'car'
WHERE re_id = '1991404f-306a-497c-8ba6-711ab54a3a51' AND (re_quote_id IS DISTINCT FROM '814a6d72-44c7-4210-b4ed-6df999324198' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1991404f-306a-497c-8ba6-711ab54a3a51
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1991404f-306a-497c-8ba6-711ab54a3a51', '2025-08-14T07:15:20.455802+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1991404f-306a-497c-8ba6-711ab54a3a51');

-- ensure reservation for 3ee93c7a-efdc-455b-9056-da3bc3260a89
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3ee93c7a-efdc-455b-9056-da3bc3260a89', '8ac7cb4b-fed4-408c-bc2e-630d01c94901', '30a9489b-d375-459a-b6f6-32695e3ca933', 'car', 'confirmed', '2025-08-14T07:15:18.758945+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3ee93c7a-efdc-455b-9056-da3bc3260a89');
UPDATE reservation SET re_quote_id = '30a9489b-d375-459a-b6f6-32695e3ca933', re_type = 'car'
WHERE re_id = '3ee93c7a-efdc-455b-9056-da3bc3260a89' AND (re_quote_id IS DISTINCT FROM '30a9489b-d375-459a-b6f6-32695e3ca933' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3ee93c7a-efdc-455b-9056-da3bc3260a89
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3ee93c7a-efdc-455b-9056-da3bc3260a89', '2025-08-14T07:15:18.758945+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3ee93c7a-efdc-455b-9056-da3bc3260a89');

-- ensure reservation for de2ab215-6933-4aa4-bd10-749a3a6d254e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'de2ab215-6933-4aa4-bd10-749a3a6d254e', '2fbd8ea4-df78-449b-8551-0ea7f3354cf2', '08cee9de-e254-4aad-a482-5613d7f15090', 'car', 'confirmed', '2025-08-14T07:15:18.184183+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'de2ab215-6933-4aa4-bd10-749a3a6d254e');
UPDATE reservation SET re_quote_id = '08cee9de-e254-4aad-a482-5613d7f15090', re_type = 'car'
WHERE re_id = 'de2ab215-6933-4aa4-bd10-749a3a6d254e' AND (re_quote_id IS DISTINCT FROM '08cee9de-e254-4aad-a482-5613d7f15090' OR re_type <> 'car');
-- reservation_cruise_car for reservation de2ab215-6933-4aa4-bd10-749a3a6d254e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'de2ab215-6933-4aa4-bd10-749a3a6d254e', '2025-08-14T07:15:18.184183+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'de2ab215-6933-4aa4-bd10-749a3a6d254e');

-- ensure reservation for 6f193eb6-578c-4cd8-aaf9-c0482fe5c64b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '6f193eb6-578c-4cd8-aaf9-c0482fe5c64b', '696ba165-b2dc-46d2-bee1-5555c4a2faf2', '1c287885-0292-41f8-91a3-542105424d12', 'car', 'confirmed', '2025-08-14T07:15:17.597531+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '6f193eb6-578c-4cd8-aaf9-c0482fe5c64b');
UPDATE reservation SET re_quote_id = '1c287885-0292-41f8-91a3-542105424d12', re_type = 'car'
WHERE re_id = '6f193eb6-578c-4cd8-aaf9-c0482fe5c64b' AND (re_quote_id IS DISTINCT FROM '1c287885-0292-41f8-91a3-542105424d12' OR re_type <> 'car');
-- reservation_cruise_car for reservation 6f193eb6-578c-4cd8-aaf9-c0482fe5c64b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '6f193eb6-578c-4cd8-aaf9-c0482fe5c64b', '2025-08-14T07:15:17.597531+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '6f193eb6-578c-4cd8-aaf9-c0482fe5c64b');

-- ensure reservation for 47ea8d2c-2a6f-4253-aea5-54507ad3bec9
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '47ea8d2c-2a6f-4253-aea5-54507ad3bec9', 'e951c831-6057-4ab8-8d34-6c92fc2b726c', '7b8b0818-6eba-40e0-8b8f-1403ec763790', 'car', 'confirmed', '2025-08-14T07:15:16.824054+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '47ea8d2c-2a6f-4253-aea5-54507ad3bec9');
UPDATE reservation SET re_quote_id = '7b8b0818-6eba-40e0-8b8f-1403ec763790', re_type = 'car'
WHERE re_id = '47ea8d2c-2a6f-4253-aea5-54507ad3bec9' AND (re_quote_id IS DISTINCT FROM '7b8b0818-6eba-40e0-8b8f-1403ec763790' OR re_type <> 'car');
-- reservation_cruise_car for reservation 47ea8d2c-2a6f-4253-aea5-54507ad3bec9
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '47ea8d2c-2a6f-4253-aea5-54507ad3bec9', '2025-08-14T07:15:16.824054+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '47ea8d2c-2a6f-4253-aea5-54507ad3bec9');

-- ensure reservation for c9df5caa-e881-45b1-851b-a60d1bf0f0f6
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c9df5caa-e881-45b1-851b-a60d1bf0f0f6', 'f7b37c82-91a0-4211-af2a-23a7fe3be02c', 'bf026a68-bb27-48f2-9a52-6aab335b57be', 'car', 'confirmed', '2025-08-14T07:15:16.262829+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c9df5caa-e881-45b1-851b-a60d1bf0f0f6');
UPDATE reservation SET re_quote_id = 'bf026a68-bb27-48f2-9a52-6aab335b57be', re_type = 'car'
WHERE re_id = 'c9df5caa-e881-45b1-851b-a60d1bf0f0f6' AND (re_quote_id IS DISTINCT FROM 'bf026a68-bb27-48f2-9a52-6aab335b57be' OR re_type <> 'car');
-- reservation_cruise_car for reservation c9df5caa-e881-45b1-851b-a60d1bf0f0f6
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c9df5caa-e881-45b1-851b-a60d1bf0f0f6', '2025-08-14T07:15:16.262829+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c9df5caa-e881-45b1-851b-a60d1bf0f0f6');

-- ensure reservation for 31aeaa05-529b-4ded-8db4-90be26f7378b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '31aeaa05-529b-4ded-8db4-90be26f7378b', '6e1f3040-20a4-44ae-b0b7-2f290e4f1c55', '814a6d72-44c7-4210-b4ed-6df999324198', 'car', 'confirmed', '2025-08-14T07:15:15.643945+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '31aeaa05-529b-4ded-8db4-90be26f7378b');
UPDATE reservation SET re_quote_id = '814a6d72-44c7-4210-b4ed-6df999324198', re_type = 'car'
WHERE re_id = '31aeaa05-529b-4ded-8db4-90be26f7378b' AND (re_quote_id IS DISTINCT FROM '814a6d72-44c7-4210-b4ed-6df999324198' OR re_type <> 'car');
-- reservation_cruise_car for reservation 31aeaa05-529b-4ded-8db4-90be26f7378b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '31aeaa05-529b-4ded-8db4-90be26f7378b', '2025-08-14T07:15:15.643945+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '31aeaa05-529b-4ded-8db4-90be26f7378b');

-- ensure reservation for 4f71638c-017b-40a8-a2e6-1d18dfe10115
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '4f71638c-017b-40a8-a2e6-1d18dfe10115', '8ac7cb4b-fed4-408c-bc2e-630d01c94901', '30a9489b-d375-459a-b6f6-32695e3ca933', 'car', 'confirmed', '2025-08-14T07:15:15.072099+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '4f71638c-017b-40a8-a2e6-1d18dfe10115');
UPDATE reservation SET re_quote_id = '30a9489b-d375-459a-b6f6-32695e3ca933', re_type = 'car'
WHERE re_id = '4f71638c-017b-40a8-a2e6-1d18dfe10115' AND (re_quote_id IS DISTINCT FROM '30a9489b-d375-459a-b6f6-32695e3ca933' OR re_type <> 'car');
-- reservation_cruise_car for reservation 4f71638c-017b-40a8-a2e6-1d18dfe10115
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '4f71638c-017b-40a8-a2e6-1d18dfe10115', '2025-08-14T07:15:15.072099+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '4f71638c-017b-40a8-a2e6-1d18dfe10115');

-- ensure reservation for 9b649c08-42f5-408a-85c0-1c3e924d8684
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '9b649c08-42f5-408a-85c0-1c3e924d8684', 'f1add170-08ac-4ef5-b73b-4a98f562aa2e', '0a5ae968-fc77-4729-a39a-e2af5c56c8f0', 'car', 'confirmed', '2025-08-14T07:15:14.497197+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '9b649c08-42f5-408a-85c0-1c3e924d8684');
UPDATE reservation SET re_quote_id = '0a5ae968-fc77-4729-a39a-e2af5c56c8f0', re_type = 'car'
WHERE re_id = '9b649c08-42f5-408a-85c0-1c3e924d8684' AND (re_quote_id IS DISTINCT FROM '0a5ae968-fc77-4729-a39a-e2af5c56c8f0' OR re_type <> 'car');
-- reservation_cruise_car for reservation 9b649c08-42f5-408a-85c0-1c3e924d8684
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '9b649c08-42f5-408a-85c0-1c3e924d8684', '2025-08-14T07:15:14.497197+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '9b649c08-42f5-408a-85c0-1c3e924d8684');

-- ensure reservation for 605e70b5-f981-4e1f-a7d2-2b759fe38ebb
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '605e70b5-f981-4e1f-a7d2-2b759fe38ebb', 'e951c831-6057-4ab8-8d34-6c92fc2b726c', '7b8b0818-6eba-40e0-8b8f-1403ec763790', 'car', 'confirmed', '2025-08-14T07:15:12.002302+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '605e70b5-f981-4e1f-a7d2-2b759fe38ebb');
UPDATE reservation SET re_quote_id = '7b8b0818-6eba-40e0-8b8f-1403ec763790', re_type = 'car'
WHERE re_id = '605e70b5-f981-4e1f-a7d2-2b759fe38ebb' AND (re_quote_id IS DISTINCT FROM '7b8b0818-6eba-40e0-8b8f-1403ec763790' OR re_type <> 'car');
-- reservation_cruise_car for reservation 605e70b5-f981-4e1f-a7d2-2b759fe38ebb
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '605e70b5-f981-4e1f-a7d2-2b759fe38ebb', '2025-08-14T07:15:12.002302+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '605e70b5-f981-4e1f-a7d2-2b759fe38ebb');

-- ensure reservation for d0c05ba3-65c4-4ca0-b09f-7a3937c3e273
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'd0c05ba3-65c4-4ca0-b09f-7a3937c3e273', '8ac7cb4b-fed4-408c-bc2e-630d01c94901', '30a9489b-d375-459a-b6f6-32695e3ca933', 'car', 'confirmed', '2025-08-14T07:15:09.667837+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'd0c05ba3-65c4-4ca0-b09f-7a3937c3e273');
UPDATE reservation SET re_quote_id = '30a9489b-d375-459a-b6f6-32695e3ca933', re_type = 'car'
WHERE re_id = 'd0c05ba3-65c4-4ca0-b09f-7a3937c3e273' AND (re_quote_id IS DISTINCT FROM '30a9489b-d375-459a-b6f6-32695e3ca933' OR re_type <> 'car');
-- reservation_cruise_car for reservation d0c05ba3-65c4-4ca0-b09f-7a3937c3e273
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'd0c05ba3-65c4-4ca0-b09f-7a3937c3e273', '2025-08-14T07:15:09.667837+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'd0c05ba3-65c4-4ca0-b09f-7a3937c3e273');

-- ensure reservation for a7b84f01-54a7-4ed2-b282-e00be44c1cc8
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'a7b84f01-54a7-4ed2-b282-e00be44c1cc8', 'f1add170-08ac-4ef5-b73b-4a98f562aa2e', '0a5ae968-fc77-4729-a39a-e2af5c56c8f0', 'car', 'confirmed', '2025-08-14T07:15:09.105858+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'a7b84f01-54a7-4ed2-b282-e00be44c1cc8');
UPDATE reservation SET re_quote_id = '0a5ae968-fc77-4729-a39a-e2af5c56c8f0', re_type = 'car'
WHERE re_id = 'a7b84f01-54a7-4ed2-b282-e00be44c1cc8' AND (re_quote_id IS DISTINCT FROM '0a5ae968-fc77-4729-a39a-e2af5c56c8f0' OR re_type <> 'car');
-- reservation_cruise_car for reservation a7b84f01-54a7-4ed2-b282-e00be44c1cc8
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'a7b84f01-54a7-4ed2-b282-e00be44c1cc8', '2025-08-14T07:15:09.105858+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'a7b84f01-54a7-4ed2-b282-e00be44c1cc8');

-- ensure reservation for e5ac75cf-43b8-45b3-ba8b-88f7c664c2b9
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e5ac75cf-43b8-45b3-ba8b-88f7c664c2b9', 'e951c831-6057-4ab8-8d34-6c92fc2b726c', '7b8b0818-6eba-40e0-8b8f-1403ec763790', 'car', 'confirmed', '2025-08-14T07:15:08.510908+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e5ac75cf-43b8-45b3-ba8b-88f7c664c2b9');
UPDATE reservation SET re_quote_id = '7b8b0818-6eba-40e0-8b8f-1403ec763790', re_type = 'car'
WHERE re_id = 'e5ac75cf-43b8-45b3-ba8b-88f7c664c2b9' AND (re_quote_id IS DISTINCT FROM '7b8b0818-6eba-40e0-8b8f-1403ec763790' OR re_type <> 'car');
-- reservation_cruise_car for reservation e5ac75cf-43b8-45b3-ba8b-88f7c664c2b9
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e5ac75cf-43b8-45b3-ba8b-88f7c664c2b9', '2025-08-14T07:15:08.510908+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e5ac75cf-43b8-45b3-ba8b-88f7c664c2b9');

-- ensure reservation for 38a759eb-0109-4698-88ce-d67ec0a6c38d
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '38a759eb-0109-4698-88ce-d67ec0a6c38d', '8ac7cb4b-fed4-408c-bc2e-630d01c94901', '30a9489b-d375-459a-b6f6-32695e3ca933', 'car', 'confirmed', '2025-08-14T07:15:07.919179+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '38a759eb-0109-4698-88ce-d67ec0a6c38d');
UPDATE reservation SET re_quote_id = '30a9489b-d375-459a-b6f6-32695e3ca933', re_type = 'car'
WHERE re_id = '38a759eb-0109-4698-88ce-d67ec0a6c38d' AND (re_quote_id IS DISTINCT FROM '30a9489b-d375-459a-b6f6-32695e3ca933' OR re_type <> 'car');
-- reservation_cruise_car for reservation 38a759eb-0109-4698-88ce-d67ec0a6c38d
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '38a759eb-0109-4698-88ce-d67ec0a6c38d', '2025-08-14T07:15:07.919179+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '38a759eb-0109-4698-88ce-d67ec0a6c38d');

-- ensure reservation for e9339eb0-11bb-4edd-ae16-bce69de5025f
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e9339eb0-11bb-4edd-ae16-bce69de5025f', 'f1add170-08ac-4ef5-b73b-4a98f562aa2e', '0a5ae968-fc77-4729-a39a-e2af5c56c8f0', 'car', 'confirmed', '2025-08-14T07:15:07.404115+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e9339eb0-11bb-4edd-ae16-bce69de5025f');
UPDATE reservation SET re_quote_id = '0a5ae968-fc77-4729-a39a-e2af5c56c8f0', re_type = 'car'
WHERE re_id = 'e9339eb0-11bb-4edd-ae16-bce69de5025f' AND (re_quote_id IS DISTINCT FROM '0a5ae968-fc77-4729-a39a-e2af5c56c8f0' OR re_type <> 'car');
-- reservation_cruise_car for reservation e9339eb0-11bb-4edd-ae16-bce69de5025f
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e9339eb0-11bb-4edd-ae16-bce69de5025f', '2025-08-14T07:15:07.404115+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e9339eb0-11bb-4edd-ae16-bce69de5025f');

-- ensure reservation for 223ae242-19a1-43e7-9b9a-8355d033ef5d
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '223ae242-19a1-43e7-9b9a-8355d033ef5d', '203b4a92-84c8-474a-9013-e1bf0ebcb08a', '4d976772-26c8-4c1f-8e5e-6222e18646b3', 'car', 'confirmed', '2025-08-14T07:15:06.262956+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '223ae242-19a1-43e7-9b9a-8355d033ef5d');
UPDATE reservation SET re_quote_id = '4d976772-26c8-4c1f-8e5e-6222e18646b3', re_type = 'car'
WHERE re_id = '223ae242-19a1-43e7-9b9a-8355d033ef5d' AND (re_quote_id IS DISTINCT FROM '4d976772-26c8-4c1f-8e5e-6222e18646b3' OR re_type <> 'car');
-- reservation_cruise_car for reservation 223ae242-19a1-43e7-9b9a-8355d033ef5d
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '223ae242-19a1-43e7-9b9a-8355d033ef5d', '2025-08-14T07:15:06.262956+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '223ae242-19a1-43e7-9b9a-8355d033ef5d');

-- ensure reservation for 2e35db77-a96d-4b5f-8d6a-ea90afeca0fa
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2e35db77-a96d-4b5f-8d6a-ea90afeca0fa', '9a31f8f0-577e-41f2-a16a-dacdfe8963b5', '91aed64f-e8ba-432e-9305-bba4e0da2a54', 'car', 'confirmed', '2025-08-14T07:15:03.279003+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2e35db77-a96d-4b5f-8d6a-ea90afeca0fa');
UPDATE reservation SET re_quote_id = '91aed64f-e8ba-432e-9305-bba4e0da2a54', re_type = 'car'
WHERE re_id = '2e35db77-a96d-4b5f-8d6a-ea90afeca0fa' AND (re_quote_id IS DISTINCT FROM '91aed64f-e8ba-432e-9305-bba4e0da2a54' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2e35db77-a96d-4b5f-8d6a-ea90afeca0fa
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2e35db77-a96d-4b5f-8d6a-ea90afeca0fa', '2025-08-14T07:15:03.279003+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2e35db77-a96d-4b5f-8d6a-ea90afeca0fa');

-- ensure reservation for 0060defa-f277-4336-a593-d288e9326cbc
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0060defa-f277-4336-a593-d288e9326cbc', '66387f6a-0bc9-4b35-a10b-53a1760ba468', '9cd22c2f-d386-4e69-88d2-6648a13e2d74', 'car', 'confirmed', '2025-08-14T07:15:02.691938+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0060defa-f277-4336-a593-d288e9326cbc');
UPDATE reservation SET re_quote_id = '9cd22c2f-d386-4e69-88d2-6648a13e2d74', re_type = 'car'
WHERE re_id = '0060defa-f277-4336-a593-d288e9326cbc' AND (re_quote_id IS DISTINCT FROM '9cd22c2f-d386-4e69-88d2-6648a13e2d74' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0060defa-f277-4336-a593-d288e9326cbc
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0060defa-f277-4336-a593-d288e9326cbc', '2025-08-14T07:15:02.691938+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0060defa-f277-4336-a593-d288e9326cbc');

-- ensure reservation for 58995342-8888-48a5-9ab6-c956faf9041a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '58995342-8888-48a5-9ab6-c956faf9041a', '8dd97710-849c-471b-84c4-2d0681168045', '4960a5ca-1806-47a7-b068-c592410e1fc6', 'car', 'confirmed', '2025-08-14T07:15:02.127265+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '58995342-8888-48a5-9ab6-c956faf9041a');
UPDATE reservation SET re_quote_id = '4960a5ca-1806-47a7-b068-c592410e1fc6', re_type = 'car'
WHERE re_id = '58995342-8888-48a5-9ab6-c956faf9041a' AND (re_quote_id IS DISTINCT FROM '4960a5ca-1806-47a7-b068-c592410e1fc6' OR re_type <> 'car');
-- reservation_cruise_car for reservation 58995342-8888-48a5-9ab6-c956faf9041a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '58995342-8888-48a5-9ab6-c956faf9041a', '2025-08-14T07:15:02.127265+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '58995342-8888-48a5-9ab6-c956faf9041a');

-- ensure reservation for 07ef403b-374d-4d91-b3b2-59a1e4f52bc2
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '07ef403b-374d-4d91-b3b2-59a1e4f52bc2', '43c23c2b-e6fd-423e-a7c0-dd06e05d3cbd', '787c113e-9ad8-4526-8640-dc0b6dc77412', 'car', 'confirmed', '2025-08-14T07:14:57.483126+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '07ef403b-374d-4d91-b3b2-59a1e4f52bc2');
UPDATE reservation SET re_quote_id = '787c113e-9ad8-4526-8640-dc0b6dc77412', re_type = 'car'
WHERE re_id = '07ef403b-374d-4d91-b3b2-59a1e4f52bc2' AND (re_quote_id IS DISTINCT FROM '787c113e-9ad8-4526-8640-dc0b6dc77412' OR re_type <> 'car');
-- reservation_cruise_car for reservation 07ef403b-374d-4d91-b3b2-59a1e4f52bc2
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '07ef403b-374d-4d91-b3b2-59a1e4f52bc2', '2025-08-14T07:14:57.483126+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '07ef403b-374d-4d91-b3b2-59a1e4f52bc2');

-- ensure reservation for a331faa0-5e1d-4ee4-bd57-c6d591edbbea
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'a331faa0-5e1d-4ee4-bd57-c6d591edbbea', '3a22e277-b5ec-4b70-923d-40ed30d663d4', '40803502-9571-4c34-a44d-0706602d15cd', 'car', 'confirmed', '2025-08-14T07:14:56.851751+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'a331faa0-5e1d-4ee4-bd57-c6d591edbbea');
UPDATE reservation SET re_quote_id = '40803502-9571-4c34-a44d-0706602d15cd', re_type = 'car'
WHERE re_id = 'a331faa0-5e1d-4ee4-bd57-c6d591edbbea' AND (re_quote_id IS DISTINCT FROM '40803502-9571-4c34-a44d-0706602d15cd' OR re_type <> 'car');
-- reservation_cruise_car for reservation a331faa0-5e1d-4ee4-bd57-c6d591edbbea
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'a331faa0-5e1d-4ee4-bd57-c6d591edbbea', '2025-08-14T07:14:56.851751+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'a331faa0-5e1d-4ee4-bd57-c6d591edbbea');

-- ensure reservation for 895a0614-15e0-494c-a4c5-81f5bfb7d242
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '895a0614-15e0-494c-a4c5-81f5bfb7d242', '3a22e277-b5ec-4b70-923d-40ed30d663d4', '40803502-9571-4c34-a44d-0706602d15cd', 'car', 'confirmed', '2025-08-14T07:14:56.236945+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '895a0614-15e0-494c-a4c5-81f5bfb7d242');
UPDATE reservation SET re_quote_id = '40803502-9571-4c34-a44d-0706602d15cd', re_type = 'car'
WHERE re_id = '895a0614-15e0-494c-a4c5-81f5bfb7d242' AND (re_quote_id IS DISTINCT FROM '40803502-9571-4c34-a44d-0706602d15cd' OR re_type <> 'car');
-- reservation_cruise_car for reservation 895a0614-15e0-494c-a4c5-81f5bfb7d242
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '895a0614-15e0-494c-a4c5-81f5bfb7d242', '2025-08-14T07:14:56.236945+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '895a0614-15e0-494c-a4c5-81f5bfb7d242');

-- ensure reservation for 61c561f9-a3a6-4f23-b811-e18322e8269b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '61c561f9-a3a6-4f23-b811-e18322e8269b', 'ce38586e-bc4b-48f2-a4c9-7d2d0011623e', '997183b8-2edd-4360-9b66-2310c695830e', 'car', 'confirmed', '2025-08-14T07:14:54.33688+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '61c561f9-a3a6-4f23-b811-e18322e8269b');
UPDATE reservation SET re_quote_id = '997183b8-2edd-4360-9b66-2310c695830e', re_type = 'car'
WHERE re_id = '61c561f9-a3a6-4f23-b811-e18322e8269b' AND (re_quote_id IS DISTINCT FROM '997183b8-2edd-4360-9b66-2310c695830e' OR re_type <> 'car');
-- reservation_cruise_car for reservation 61c561f9-a3a6-4f23-b811-e18322e8269b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '61c561f9-a3a6-4f23-b811-e18322e8269b', '2025-08-14T07:14:54.33688+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '61c561f9-a3a6-4f23-b811-e18322e8269b');

-- ensure reservation for 3801e0ac-a870-471f-ab16-d8293682f150
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3801e0ac-a870-471f-ab16-d8293682f150', '53c79979-20d7-4a9a-a903-736d8811be48', '3c27b90c-d376-4df2-9aa5-349f2905e68c', 'car', 'confirmed', '2025-08-14T07:14:53.809325+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3801e0ac-a870-471f-ab16-d8293682f150');
UPDATE reservation SET re_quote_id = '3c27b90c-d376-4df2-9aa5-349f2905e68c', re_type = 'car'
WHERE re_id = '3801e0ac-a870-471f-ab16-d8293682f150' AND (re_quote_id IS DISTINCT FROM '3c27b90c-d376-4df2-9aa5-349f2905e68c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3801e0ac-a870-471f-ab16-d8293682f150
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3801e0ac-a870-471f-ab16-d8293682f150', '2025-08-14T07:14:53.809325+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3801e0ac-a870-471f-ab16-d8293682f150');

-- ensure reservation for 20d0d9bc-0b4b-4614-bce1-29f0ee0c4755
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '20d0d9bc-0b4b-4614-bce1-29f0ee0c4755', '53c79979-20d7-4a9a-a903-736d8811be48', '3c27b90c-d376-4df2-9aa5-349f2905e68c', 'car', 'confirmed', '2025-08-14T07:14:53.271695+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '20d0d9bc-0b4b-4614-bce1-29f0ee0c4755');
UPDATE reservation SET re_quote_id = '3c27b90c-d376-4df2-9aa5-349f2905e68c', re_type = 'car'
WHERE re_id = '20d0d9bc-0b4b-4614-bce1-29f0ee0c4755' AND (re_quote_id IS DISTINCT FROM '3c27b90c-d376-4df2-9aa5-349f2905e68c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 20d0d9bc-0b4b-4614-bce1-29f0ee0c4755
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '20d0d9bc-0b4b-4614-bce1-29f0ee0c4755', '2025-08-14T07:14:53.271695+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '20d0d9bc-0b4b-4614-bce1-29f0ee0c4755');

-- ensure reservation for 8b03afbb-90dd-4043-9cd1-f5a4baa2df5b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '8b03afbb-90dd-4043-9cd1-f5a4baa2df5b', '0881ec9a-02b5-414e-a8e9-9c7ab9114018', 'b9a618ad-a14e-4900-8a58-5a9efae8d8a5', 'car', 'confirmed', '2025-08-14T07:14:52.657378+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '8b03afbb-90dd-4043-9cd1-f5a4baa2df5b');
UPDATE reservation SET re_quote_id = 'b9a618ad-a14e-4900-8a58-5a9efae8d8a5', re_type = 'car'
WHERE re_id = '8b03afbb-90dd-4043-9cd1-f5a4baa2df5b' AND (re_quote_id IS DISTINCT FROM 'b9a618ad-a14e-4900-8a58-5a9efae8d8a5' OR re_type <> 'car');
-- reservation_cruise_car for reservation 8b03afbb-90dd-4043-9cd1-f5a4baa2df5b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '8b03afbb-90dd-4043-9cd1-f5a4baa2df5b', '2025-08-14T07:14:52.657378+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '8b03afbb-90dd-4043-9cd1-f5a4baa2df5b');

-- ensure reservation for b5d72eba-e417-4548-8b29-74d930d421ca
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'b5d72eba-e417-4548-8b29-74d930d421ca', 'd16d4934-e2b5-4817-a586-1a37ef4dac81', 'eeaf8ca9-31da-457d-80dc-2bb94c31cd09', 'car', 'confirmed', '2025-08-14T07:14:47.262625+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'b5d72eba-e417-4548-8b29-74d930d421ca');
UPDATE reservation SET re_quote_id = 'eeaf8ca9-31da-457d-80dc-2bb94c31cd09', re_type = 'car'
WHERE re_id = 'b5d72eba-e417-4548-8b29-74d930d421ca' AND (re_quote_id IS DISTINCT FROM 'eeaf8ca9-31da-457d-80dc-2bb94c31cd09' OR re_type <> 'car');
-- reservation_cruise_car for reservation b5d72eba-e417-4548-8b29-74d930d421ca
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'b5d72eba-e417-4548-8b29-74d930d421ca', '2025-08-14T07:14:47.262625+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'b5d72eba-e417-4548-8b29-74d930d421ca');

-- ensure reservation for 3abca8f5-5cff-4fbb-b0d0-28452b87ee3c
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3abca8f5-5cff-4fbb-b0d0-28452b87ee3c', '5c3df1ce-2698-4c8c-8dfb-42c19eb11b1d', '33b0803b-6fb6-43d8-b7ea-87cddae64987', 'car', 'confirmed', '2025-08-14T07:14:45.217732+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3abca8f5-5cff-4fbb-b0d0-28452b87ee3c');
UPDATE reservation SET re_quote_id = '33b0803b-6fb6-43d8-b7ea-87cddae64987', re_type = 'car'
WHERE re_id = '3abca8f5-5cff-4fbb-b0d0-28452b87ee3c' AND (re_quote_id IS DISTINCT FROM '33b0803b-6fb6-43d8-b7ea-87cddae64987' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3abca8f5-5cff-4fbb-b0d0-28452b87ee3c
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3abca8f5-5cff-4fbb-b0d0-28452b87ee3c', '2025-08-14T07:14:45.217732+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3abca8f5-5cff-4fbb-b0d0-28452b87ee3c');

-- ensure reservation for 2ee191ac-257b-4c5d-92e2-aa3eaa6008bf
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2ee191ac-257b-4c5d-92e2-aa3eaa6008bf', 'f191b922-6b3a-44dc-bed2-35aeab863585', '2f5fa214-56a3-44f4-abd1-0a347ce50dad', 'car', 'confirmed', '2025-08-14T07:14:44.608029+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2ee191ac-257b-4c5d-92e2-aa3eaa6008bf');
UPDATE reservation SET re_quote_id = '2f5fa214-56a3-44f4-abd1-0a347ce50dad', re_type = 'car'
WHERE re_id = '2ee191ac-257b-4c5d-92e2-aa3eaa6008bf' AND (re_quote_id IS DISTINCT FROM '2f5fa214-56a3-44f4-abd1-0a347ce50dad' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2ee191ac-257b-4c5d-92e2-aa3eaa6008bf
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2ee191ac-257b-4c5d-92e2-aa3eaa6008bf', '2025-08-14T07:14:44.608029+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2ee191ac-257b-4c5d-92e2-aa3eaa6008bf');

-- ensure reservation for 07620643-8637-45ee-8517-ccfb10a73326
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '07620643-8637-45ee-8517-ccfb10a73326', '494b78c1-d704-4462-ac1e-a60311b6c501', 'bd3bc1dc-6200-43db-9d7c-217799b684ed', 'car', 'confirmed', '2025-08-14T07:14:43.995863+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '07620643-8637-45ee-8517-ccfb10a73326');
UPDATE reservation SET re_quote_id = 'bd3bc1dc-6200-43db-9d7c-217799b684ed', re_type = 'car'
WHERE re_id = '07620643-8637-45ee-8517-ccfb10a73326' AND (re_quote_id IS DISTINCT FROM 'bd3bc1dc-6200-43db-9d7c-217799b684ed' OR re_type <> 'car');
-- reservation_cruise_car for reservation 07620643-8637-45ee-8517-ccfb10a73326
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '07620643-8637-45ee-8517-ccfb10a73326', '2025-08-14T07:14:43.995863+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '07620643-8637-45ee-8517-ccfb10a73326');

-- ensure reservation for a4eacde0-c101-4fc7-b035-52481e9766ca
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'a4eacde0-c101-4fc7-b035-52481e9766ca', '745cf7eb-c694-4adf-bd27-f4e103820df7', '48180fe3-6abd-4c3e-b886-0a5d562bf6d8', 'car', 'confirmed', '2025-08-14T07:14:43.438198+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'a4eacde0-c101-4fc7-b035-52481e9766ca');
UPDATE reservation SET re_quote_id = '48180fe3-6abd-4c3e-b886-0a5d562bf6d8', re_type = 'car'
WHERE re_id = 'a4eacde0-c101-4fc7-b035-52481e9766ca' AND (re_quote_id IS DISTINCT FROM '48180fe3-6abd-4c3e-b886-0a5d562bf6d8' OR re_type <> 'car');
-- reservation_cruise_car for reservation a4eacde0-c101-4fc7-b035-52481e9766ca
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'a4eacde0-c101-4fc7-b035-52481e9766ca', '2025-08-14T07:14:43.438198+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'a4eacde0-c101-4fc7-b035-52481e9766ca');

-- ensure reservation for 085c5b7a-832c-495e-b30d-c717d5442496
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '085c5b7a-832c-495e-b30d-c717d5442496', '46ccebc4-c5fb-4c70-a3ba-58ae982622c6', '8d34c8a1-9e71-460f-9ca7-b97110d66793', 'car', 'confirmed', '2025-08-14T07:14:42.828612+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '085c5b7a-832c-495e-b30d-c717d5442496');
UPDATE reservation SET re_quote_id = '8d34c8a1-9e71-460f-9ca7-b97110d66793', re_type = 'car'
WHERE re_id = '085c5b7a-832c-495e-b30d-c717d5442496' AND (re_quote_id IS DISTINCT FROM '8d34c8a1-9e71-460f-9ca7-b97110d66793' OR re_type <> 'car');
-- reservation_cruise_car for reservation 085c5b7a-832c-495e-b30d-c717d5442496
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '085c5b7a-832c-495e-b30d-c717d5442496', '2025-08-14T07:14:42.828612+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '085c5b7a-832c-495e-b30d-c717d5442496');

-- ensure reservation for 262ebea9-d272-401b-b503-5fc4bf414f2e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '262ebea9-d272-401b-b503-5fc4bf414f2e', '0ba61aa4-3c11-459c-9faf-4cc36b699f94', 'fd0790c6-e992-4115-a2c1-2e683bb97d55', 'car', 'confirmed', '2025-08-14T07:14:42.04508+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '262ebea9-d272-401b-b503-5fc4bf414f2e');
UPDATE reservation SET re_quote_id = 'fd0790c6-e992-4115-a2c1-2e683bb97d55', re_type = 'car'
WHERE re_id = '262ebea9-d272-401b-b503-5fc4bf414f2e' AND (re_quote_id IS DISTINCT FROM 'fd0790c6-e992-4115-a2c1-2e683bb97d55' OR re_type <> 'car');
-- reservation_cruise_car for reservation 262ebea9-d272-401b-b503-5fc4bf414f2e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '262ebea9-d272-401b-b503-5fc4bf414f2e', '2025-08-14T07:14:42.04508+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '262ebea9-d272-401b-b503-5fc4bf414f2e');

-- ensure reservation for 68f9d64e-5663-45ce-87ca-a19cb6809746
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '68f9d64e-5663-45ce-87ca-a19cb6809746', '37b1ee61-4f0b-4768-a867-92a9e67996fd', '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', 'car', 'confirmed', '2025-08-14T07:14:41.273937+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '68f9d64e-5663-45ce-87ca-a19cb6809746');
UPDATE reservation SET re_quote_id = '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', re_type = 'car'
WHERE re_id = '68f9d64e-5663-45ce-87ca-a19cb6809746' AND (re_quote_id IS DISTINCT FROM '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7' OR re_type <> 'car');
-- reservation_cruise_car for reservation 68f9d64e-5663-45ce-87ca-a19cb6809746
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '68f9d64e-5663-45ce-87ca-a19cb6809746', '2025-08-14T07:14:41.273937+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '68f9d64e-5663-45ce-87ca-a19cb6809746');

-- ensure reservation for 3c033972-701c-4de7-93a7-ac73da90743a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3c033972-701c-4de7-93a7-ac73da90743a', '064f9320-a30c-41eb-b3bd-3005aee2d48b', '0af0fe21-2adc-43b9-aaab-68409e55ca2f', 'car', 'confirmed', '2025-08-14T07:14:39.535257+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3c033972-701c-4de7-93a7-ac73da90743a');
UPDATE reservation SET re_quote_id = '0af0fe21-2adc-43b9-aaab-68409e55ca2f', re_type = 'car'
WHERE re_id = '3c033972-701c-4de7-93a7-ac73da90743a' AND (re_quote_id IS DISTINCT FROM '0af0fe21-2adc-43b9-aaab-68409e55ca2f' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3c033972-701c-4de7-93a7-ac73da90743a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3c033972-701c-4de7-93a7-ac73da90743a', '2025-08-14T07:14:39.535257+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3c033972-701c-4de7-93a7-ac73da90743a');

-- ensure reservation for 97ae6590-adae-4676-9bb7-31c503d185c7
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '97ae6590-adae-4676-9bb7-31c503d185c7', '064f9320-a30c-41eb-b3bd-3005aee2d48b', '0af0fe21-2adc-43b9-aaab-68409e55ca2f', 'car', 'confirmed', '2025-08-14T07:14:38.848281+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '97ae6590-adae-4676-9bb7-31c503d185c7');
UPDATE reservation SET re_quote_id = '0af0fe21-2adc-43b9-aaab-68409e55ca2f', re_type = 'car'
WHERE re_id = '97ae6590-adae-4676-9bb7-31c503d185c7' AND (re_quote_id IS DISTINCT FROM '0af0fe21-2adc-43b9-aaab-68409e55ca2f' OR re_type <> 'car');
-- reservation_cruise_car for reservation 97ae6590-adae-4676-9bb7-31c503d185c7
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '97ae6590-adae-4676-9bb7-31c503d185c7', '2025-08-14T07:14:38.848281+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '97ae6590-adae-4676-9bb7-31c503d185c7');

-- ensure reservation for d02434a2-2060-4ff7-8efb-742fd897d583
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'd02434a2-2060-4ff7-8efb-742fd897d583', 'dbb68130-0331-415f-9461-79e3936ef9af', '82a3151f-c2d8-4ca1-a2ed-29bb3de55edc', 'car', 'confirmed', '2025-08-14T07:14:37.691406+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'd02434a2-2060-4ff7-8efb-742fd897d583');
UPDATE reservation SET re_quote_id = '82a3151f-c2d8-4ca1-a2ed-29bb3de55edc', re_type = 'car'
WHERE re_id = 'd02434a2-2060-4ff7-8efb-742fd897d583' AND (re_quote_id IS DISTINCT FROM '82a3151f-c2d8-4ca1-a2ed-29bb3de55edc' OR re_type <> 'car');
-- reservation_cruise_car for reservation d02434a2-2060-4ff7-8efb-742fd897d583
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'd02434a2-2060-4ff7-8efb-742fd897d583', '2025-08-14T07:14:37.691406+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'd02434a2-2060-4ff7-8efb-742fd897d583');

-- ensure reservation for 791648ce-ccdf-4929-9de4-d734bbe9f261
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '791648ce-ccdf-4929-9de4-d734bbe9f261', 'dbb68130-0331-415f-9461-79e3936ef9af', '82a3151f-c2d8-4ca1-a2ed-29bb3de55edc', 'car', 'confirmed', '2025-08-14T07:14:37.114761+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '791648ce-ccdf-4929-9de4-d734bbe9f261');
UPDATE reservation SET re_quote_id = '82a3151f-c2d8-4ca1-a2ed-29bb3de55edc', re_type = 'car'
WHERE re_id = '791648ce-ccdf-4929-9de4-d734bbe9f261' AND (re_quote_id IS DISTINCT FROM '82a3151f-c2d8-4ca1-a2ed-29bb3de55edc' OR re_type <> 'car');
-- reservation_cruise_car for reservation 791648ce-ccdf-4929-9de4-d734bbe9f261
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '791648ce-ccdf-4929-9de4-d734bbe9f261', '2025-08-14T07:14:37.114761+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '791648ce-ccdf-4929-9de4-d734bbe9f261');

-- ensure reservation for eab49db6-cf32-4c4f-9625-904861d28440
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'eab49db6-cf32-4c4f-9625-904861d28440', '9fccaeab-2a27-41ca-9def-495025f0dd3c', '21870c18-6108-4839-9c7f-19bec077ac7e', 'car', 'confirmed', '2025-08-14T07:14:34.543378+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'eab49db6-cf32-4c4f-9625-904861d28440');
UPDATE reservation SET re_quote_id = '21870c18-6108-4839-9c7f-19bec077ac7e', re_type = 'car'
WHERE re_id = 'eab49db6-cf32-4c4f-9625-904861d28440' AND (re_quote_id IS DISTINCT FROM '21870c18-6108-4839-9c7f-19bec077ac7e' OR re_type <> 'car');
-- reservation_cruise_car for reservation eab49db6-cf32-4c4f-9625-904861d28440
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'eab49db6-cf32-4c4f-9625-904861d28440', '2025-08-14T07:14:34.543378+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'eab49db6-cf32-4c4f-9625-904861d28440');

-- ensure reservation for 664e63fb-32ef-4e1c-a152-715b4ae8ad4a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '664e63fb-32ef-4e1c-a152-715b4ae8ad4a', '6b1bcf1a-3100-4be4-b41e-bd0ef33354a7', '0fa585fa-13d5-4a64-9ba4-7cfbf4cb856b', 'car', 'confirmed', '2025-08-14T07:14:33.824139+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '664e63fb-32ef-4e1c-a152-715b4ae8ad4a');
UPDATE reservation SET re_quote_id = '0fa585fa-13d5-4a64-9ba4-7cfbf4cb856b', re_type = 'car'
WHERE re_id = '664e63fb-32ef-4e1c-a152-715b4ae8ad4a' AND (re_quote_id IS DISTINCT FROM '0fa585fa-13d5-4a64-9ba4-7cfbf4cb856b' OR re_type <> 'car');
-- reservation_cruise_car for reservation 664e63fb-32ef-4e1c-a152-715b4ae8ad4a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '664e63fb-32ef-4e1c-a152-715b4ae8ad4a', '2025-08-14T07:14:33.824139+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '664e63fb-32ef-4e1c-a152-715b4ae8ad4a');

-- ensure reservation for c91176b6-6a3f-460e-bff8-b670265ff662
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c91176b6-6a3f-460e-bff8-b670265ff662', 'c0e99691-6c30-412d-85e7-6467eb3c6c8a', '7691cf2f-45ac-44ef-a6f8-0b9d531473ea', 'car', 'confirmed', '2025-08-14T07:14:31.111097+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c91176b6-6a3f-460e-bff8-b670265ff662');
UPDATE reservation SET re_quote_id = '7691cf2f-45ac-44ef-a6f8-0b9d531473ea', re_type = 'car'
WHERE re_id = 'c91176b6-6a3f-460e-bff8-b670265ff662' AND (re_quote_id IS DISTINCT FROM '7691cf2f-45ac-44ef-a6f8-0b9d531473ea' OR re_type <> 'car');
-- reservation_cruise_car for reservation c91176b6-6a3f-460e-bff8-b670265ff662
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c91176b6-6a3f-460e-bff8-b670265ff662', '2025-08-14T07:14:31.111097+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c91176b6-6a3f-460e-bff8-b670265ff662');

-- ensure reservation for 783b20a3-f587-4285-b08d-3ad1b4b16b5b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '783b20a3-f587-4285-b08d-3ad1b4b16b5b', 'c0e99691-6c30-412d-85e7-6467eb3c6c8a', '7691cf2f-45ac-44ef-a6f8-0b9d531473ea', 'car', 'confirmed', '2025-08-14T07:14:30.438215+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '783b20a3-f587-4285-b08d-3ad1b4b16b5b');
UPDATE reservation SET re_quote_id = '7691cf2f-45ac-44ef-a6f8-0b9d531473ea', re_type = 'car'
WHERE re_id = '783b20a3-f587-4285-b08d-3ad1b4b16b5b' AND (re_quote_id IS DISTINCT FROM '7691cf2f-45ac-44ef-a6f8-0b9d531473ea' OR re_type <> 'car');
-- reservation_cruise_car for reservation 783b20a3-f587-4285-b08d-3ad1b4b16b5b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '783b20a3-f587-4285-b08d-3ad1b4b16b5b', '2025-08-14T07:14:30.438215+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '783b20a3-f587-4285-b08d-3ad1b4b16b5b');

-- ensure reservation for ec0068a1-b176-4bfa-b6c0-18330c385257
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'ec0068a1-b176-4bfa-b6c0-18330c385257', '37b1ee61-4f0b-4768-a867-92a9e67996fd', '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', 'car', 'confirmed', '2025-08-14T07:14:24.154452+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'ec0068a1-b176-4bfa-b6c0-18330c385257');
UPDATE reservation SET re_quote_id = '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', re_type = 'car'
WHERE re_id = 'ec0068a1-b176-4bfa-b6c0-18330c385257' AND (re_quote_id IS DISTINCT FROM '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7' OR re_type <> 'car');
-- reservation_cruise_car for reservation ec0068a1-b176-4bfa-b6c0-18330c385257
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'ec0068a1-b176-4bfa-b6c0-18330c385257', '2025-08-14T07:14:24.154452+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'ec0068a1-b176-4bfa-b6c0-18330c385257');

-- ensure reservation for 9756371b-00c1-41fc-a1d2-632d74247688
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '9756371b-00c1-41fc-a1d2-632d74247688', '37b1ee61-4f0b-4768-a867-92a9e67996fd', '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', 'car', 'confirmed', '2025-08-14T07:14:23.512364+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '9756371b-00c1-41fc-a1d2-632d74247688');
UPDATE reservation SET re_quote_id = '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', re_type = 'car'
WHERE re_id = '9756371b-00c1-41fc-a1d2-632d74247688' AND (re_quote_id IS DISTINCT FROM '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7' OR re_type <> 'car');
-- reservation_cruise_car for reservation 9756371b-00c1-41fc-a1d2-632d74247688
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '9756371b-00c1-41fc-a1d2-632d74247688', '2025-08-14T07:14:23.512364+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '9756371b-00c1-41fc-a1d2-632d74247688');

-- ensure reservation for 2baa2c2a-9eec-4fb7-8f97-29c5aa43eb7c
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2baa2c2a-9eec-4fb7-8f97-29c5aa43eb7c', '37b1ee61-4f0b-4768-a867-92a9e67996fd', '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', 'car', 'confirmed', '2025-08-14T07:14:21.749482+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2baa2c2a-9eec-4fb7-8f97-29c5aa43eb7c');
UPDATE reservation SET re_quote_id = '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', re_type = 'car'
WHERE re_id = '2baa2c2a-9eec-4fb7-8f97-29c5aa43eb7c' AND (re_quote_id IS DISTINCT FROM '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2baa2c2a-9eec-4fb7-8f97-29c5aa43eb7c
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2baa2c2a-9eec-4fb7-8f97-29c5aa43eb7c', '2025-08-14T07:14:21.749482+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2baa2c2a-9eec-4fb7-8f97-29c5aa43eb7c');

-- ensure reservation for af15228b-57c6-4226-aa05-3029c80170f6
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'af15228b-57c6-4226-aa05-3029c80170f6', 'f191b922-6b3a-44dc-bed2-35aeab863585', '2f5fa214-56a3-44f4-abd1-0a347ce50dad', 'car', 'confirmed', '2025-08-14T07:14:17.525271+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'af15228b-57c6-4226-aa05-3029c80170f6');
UPDATE reservation SET re_quote_id = '2f5fa214-56a3-44f4-abd1-0a347ce50dad', re_type = 'car'
WHERE re_id = 'af15228b-57c6-4226-aa05-3029c80170f6' AND (re_quote_id IS DISTINCT FROM '2f5fa214-56a3-44f4-abd1-0a347ce50dad' OR re_type <> 'car');
-- reservation_cruise_car for reservation af15228b-57c6-4226-aa05-3029c80170f6
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'af15228b-57c6-4226-aa05-3029c80170f6', '2025-08-14T07:14:17.525271+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'af15228b-57c6-4226-aa05-3029c80170f6');

-- ensure reservation for 1a528fd6-495c-4baf-a917-03d0ef5eba3a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1a528fd6-495c-4baf-a917-03d0ef5eba3a', '09a62972-756b-4883-9f81-95af92afaa01', 'af7417bd-bfa3-452a-9a1f-94c929143fd6', 'car', 'confirmed', '2025-08-14T07:14:12.711955+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1a528fd6-495c-4baf-a917-03d0ef5eba3a');
UPDATE reservation SET re_quote_id = 'af7417bd-bfa3-452a-9a1f-94c929143fd6', re_type = 'car'
WHERE re_id = '1a528fd6-495c-4baf-a917-03d0ef5eba3a' AND (re_quote_id IS DISTINCT FROM 'af7417bd-bfa3-452a-9a1f-94c929143fd6' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1a528fd6-495c-4baf-a917-03d0ef5eba3a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1a528fd6-495c-4baf-a917-03d0ef5eba3a', '2025-08-14T07:14:12.711955+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1a528fd6-495c-4baf-a917-03d0ef5eba3a');

-- ensure reservation for 9d54492a-1f57-4695-b5f1-6385f9994d18
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '9d54492a-1f57-4695-b5f1-6385f9994d18', 'd8b9b80d-e543-40a5-9d7e-5259b2e2fd61', '4474d2e9-855e-4045-aa20-d99e08891279', 'car', 'confirmed', '2025-08-14T07:14:12.150053+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '9d54492a-1f57-4695-b5f1-6385f9994d18');
UPDATE reservation SET re_quote_id = '4474d2e9-855e-4045-aa20-d99e08891279', re_type = 'car'
WHERE re_id = '9d54492a-1f57-4695-b5f1-6385f9994d18' AND (re_quote_id IS DISTINCT FROM '4474d2e9-855e-4045-aa20-d99e08891279' OR re_type <> 'car');
-- reservation_cruise_car for reservation 9d54492a-1f57-4695-b5f1-6385f9994d18
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '9d54492a-1f57-4695-b5f1-6385f9994d18', '2025-08-14T07:14:12.150053+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '9d54492a-1f57-4695-b5f1-6385f9994d18');

-- ensure reservation for fc90c4fe-8550-4392-a142-6e188974d2c8
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'fc90c4fe-8550-4392-a142-6e188974d2c8', '9a09c4c6-beb8-49f5-be4d-9cc2464f4854', '683f6436-c19d-443a-82c5-d8bdb4befa10', 'car', 'confirmed', '2025-08-14T07:14:05.928111+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'fc90c4fe-8550-4392-a142-6e188974d2c8');
UPDATE reservation SET re_quote_id = '683f6436-c19d-443a-82c5-d8bdb4befa10', re_type = 'car'
WHERE re_id = 'fc90c4fe-8550-4392-a142-6e188974d2c8' AND (re_quote_id IS DISTINCT FROM '683f6436-c19d-443a-82c5-d8bdb4befa10' OR re_type <> 'car');
-- reservation_cruise_car for reservation fc90c4fe-8550-4392-a142-6e188974d2c8
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'fc90c4fe-8550-4392-a142-6e188974d2c8', '2025-08-14T07:14:05.928111+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'fc90c4fe-8550-4392-a142-6e188974d2c8');

-- ensure reservation for 95cedc6a-6e74-4d00-b807-5c4472ba4b52
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '95cedc6a-6e74-4d00-b807-5c4472ba4b52', 'bc140154-b991-4b5a-a815-9dcec9cfa8bc', 'ba7dbcba-5965-4a57-ac29-34f9aa1cdb8f', 'car', 'confirmed', '2025-08-14T07:14:04.028202+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '95cedc6a-6e74-4d00-b807-5c4472ba4b52');
UPDATE reservation SET re_quote_id = 'ba7dbcba-5965-4a57-ac29-34f9aa1cdb8f', re_type = 'car'
WHERE re_id = '95cedc6a-6e74-4d00-b807-5c4472ba4b52' AND (re_quote_id IS DISTINCT FROM 'ba7dbcba-5965-4a57-ac29-34f9aa1cdb8f' OR re_type <> 'car');
-- reservation_cruise_car for reservation 95cedc6a-6e74-4d00-b807-5c4472ba4b52
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '95cedc6a-6e74-4d00-b807-5c4472ba4b52', '2025-08-14T07:14:04.028202+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '95cedc6a-6e74-4d00-b807-5c4472ba4b52');

-- ensure reservation for 06986188-619b-4364-b1b5-67b851adfac7
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '06986188-619b-4364-b1b5-67b851adfac7', '19eedaba-d65d-42f5-9ce6-b0b37c817ca3', '46164f57-c968-456d-a0ff-b6d841fe7ffd', 'car', 'confirmed', '2025-08-14T07:14:02.837716+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '06986188-619b-4364-b1b5-67b851adfac7');
UPDATE reservation SET re_quote_id = '46164f57-c968-456d-a0ff-b6d841fe7ffd', re_type = 'car'
WHERE re_id = '06986188-619b-4364-b1b5-67b851adfac7' AND (re_quote_id IS DISTINCT FROM '46164f57-c968-456d-a0ff-b6d841fe7ffd' OR re_type <> 'car');
-- reservation_cruise_car for reservation 06986188-619b-4364-b1b5-67b851adfac7
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '06986188-619b-4364-b1b5-67b851adfac7', '2025-08-14T07:14:02.837716+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '06986188-619b-4364-b1b5-67b851adfac7');

-- ensure reservation for db917961-5356-4827-a788-6befc7ccbb68
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'db917961-5356-4827-a788-6befc7ccbb68', '19eedaba-d65d-42f5-9ce6-b0b37c817ca3', '46164f57-c968-456d-a0ff-b6d841fe7ffd', 'car', 'confirmed', '2025-08-14T07:14:02.246627+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'db917961-5356-4827-a788-6befc7ccbb68');
UPDATE reservation SET re_quote_id = '46164f57-c968-456d-a0ff-b6d841fe7ffd', re_type = 'car'
WHERE re_id = 'db917961-5356-4827-a788-6befc7ccbb68' AND (re_quote_id IS DISTINCT FROM '46164f57-c968-456d-a0ff-b6d841fe7ffd' OR re_type <> 'car');
-- reservation_cruise_car for reservation db917961-5356-4827-a788-6befc7ccbb68
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'db917961-5356-4827-a788-6befc7ccbb68', '2025-08-14T07:14:02.246627+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'db917961-5356-4827-a788-6befc7ccbb68');

-- ensure reservation for 5b02b8df-ce46-4947-8ad8-d705762981a1
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '5b02b8df-ce46-4947-8ad8-d705762981a1', '19eedaba-d65d-42f5-9ce6-b0b37c817ca3', '46164f57-c968-456d-a0ff-b6d841fe7ffd', 'car', 'confirmed', '2025-08-14T07:14:01.496118+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '5b02b8df-ce46-4947-8ad8-d705762981a1');
UPDATE reservation SET re_quote_id = '46164f57-c968-456d-a0ff-b6d841fe7ffd', re_type = 'car'
WHERE re_id = '5b02b8df-ce46-4947-8ad8-d705762981a1' AND (re_quote_id IS DISTINCT FROM '46164f57-c968-456d-a0ff-b6d841fe7ffd' OR re_type <> 'car');
-- reservation_cruise_car for reservation 5b02b8df-ce46-4947-8ad8-d705762981a1
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '5b02b8df-ce46-4947-8ad8-d705762981a1', '2025-08-14T07:14:01.496118+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '5b02b8df-ce46-4947-8ad8-d705762981a1');

-- ensure reservation for 12178040-1bab-41ad-b9c3-d3ab8bedc765
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '12178040-1bab-41ad-b9c3-d3ab8bedc765', 'ef20f8d3-99f5-4ec9-a0ec-d12245ecfcd6', '78c653d7-7592-466d-bca6-9e4e87bdb03b', 'car', 'confirmed', '2025-08-14T07:14:00.361967+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '12178040-1bab-41ad-b9c3-d3ab8bedc765');
UPDATE reservation SET re_quote_id = '78c653d7-7592-466d-bca6-9e4e87bdb03b', re_type = 'car'
WHERE re_id = '12178040-1bab-41ad-b9c3-d3ab8bedc765' AND (re_quote_id IS DISTINCT FROM '78c653d7-7592-466d-bca6-9e4e87bdb03b' OR re_type <> 'car');
-- reservation_cruise_car for reservation 12178040-1bab-41ad-b9c3-d3ab8bedc765
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '12178040-1bab-41ad-b9c3-d3ab8bedc765', '2025-08-14T07:14:00.361967+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '12178040-1bab-41ad-b9c3-d3ab8bedc765');

-- ensure reservation for fae46c2a-ab78-4c49-b015-c38db257e39d
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'fae46c2a-ab78-4c49-b015-c38db257e39d', '7f293207-44ce-4bf7-be36-6af09ac354c0', '349fd2bf-a8c9-46e0-a3e1-10a14f6f28a3', 'car', 'confirmed', '2025-08-14T07:13:59.629706+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'fae46c2a-ab78-4c49-b015-c38db257e39d');
UPDATE reservation SET re_quote_id = '349fd2bf-a8c9-46e0-a3e1-10a14f6f28a3', re_type = 'car'
WHERE re_id = 'fae46c2a-ab78-4c49-b015-c38db257e39d' AND (re_quote_id IS DISTINCT FROM '349fd2bf-a8c9-46e0-a3e1-10a14f6f28a3' OR re_type <> 'car');
-- reservation_cruise_car for reservation fae46c2a-ab78-4c49-b015-c38db257e39d
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'fae46c2a-ab78-4c49-b015-c38db257e39d', '2025-08-14T07:13:59.629706+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'fae46c2a-ab78-4c49-b015-c38db257e39d');

-- ensure reservation for b5fd1f34-9cb1-4385-9bae-f22cf17f1806
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'b5fd1f34-9cb1-4385-9bae-f22cf17f1806', '02604eab-04fd-4135-a255-ad334d1e3b88', '3e23d64e-2b81-4f7f-a5a4-fe8e24280467', 'car', 'confirmed', '2025-08-14T07:13:57.765826+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'b5fd1f34-9cb1-4385-9bae-f22cf17f1806');
UPDATE reservation SET re_quote_id = '3e23d64e-2b81-4f7f-a5a4-fe8e24280467', re_type = 'car'
WHERE re_id = 'b5fd1f34-9cb1-4385-9bae-f22cf17f1806' AND (re_quote_id IS DISTINCT FROM '3e23d64e-2b81-4f7f-a5a4-fe8e24280467' OR re_type <> 'car');
-- reservation_cruise_car for reservation b5fd1f34-9cb1-4385-9bae-f22cf17f1806
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'b5fd1f34-9cb1-4385-9bae-f22cf17f1806', '2025-08-14T07:13:57.765826+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'b5fd1f34-9cb1-4385-9bae-f22cf17f1806');

-- ensure reservation for e302fb32-cff5-4bd8-a76f-de22f66e01aa
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e302fb32-cff5-4bd8-a76f-de22f66e01aa', 'd32f13f7-828d-4a67-81ef-6b4ec81dbe65', '827101b4-4efe-4af7-8083-cfcb68d23237', 'car', 'confirmed', '2025-08-14T07:13:55.948447+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e302fb32-cff5-4bd8-a76f-de22f66e01aa');
UPDATE reservation SET re_quote_id = '827101b4-4efe-4af7-8083-cfcb68d23237', re_type = 'car'
WHERE re_id = 'e302fb32-cff5-4bd8-a76f-de22f66e01aa' AND (re_quote_id IS DISTINCT FROM '827101b4-4efe-4af7-8083-cfcb68d23237' OR re_type <> 'car');
-- reservation_cruise_car for reservation e302fb32-cff5-4bd8-a76f-de22f66e01aa
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e302fb32-cff5-4bd8-a76f-de22f66e01aa', '2025-08-14T07:13:55.948447+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e302fb32-cff5-4bd8-a76f-de22f66e01aa');

-- ensure reservation for a592c8c9-5887-43e4-905d-6f513d755484
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'a592c8c9-5887-43e4-905d-6f513d755484', 'c9eba585-ab71-4f71-b285-ce203cc38699', '2eb89508-06fa-4fa3-a3df-eb4b6bfe9289', 'car', 'confirmed', '2025-08-14T07:13:55.238084+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'a592c8c9-5887-43e4-905d-6f513d755484');
UPDATE reservation SET re_quote_id = '2eb89508-06fa-4fa3-a3df-eb4b6bfe9289', re_type = 'car'
WHERE re_id = 'a592c8c9-5887-43e4-905d-6f513d755484' AND (re_quote_id IS DISTINCT FROM '2eb89508-06fa-4fa3-a3df-eb4b6bfe9289' OR re_type <> 'car');
-- reservation_cruise_car for reservation a592c8c9-5887-43e4-905d-6f513d755484
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'a592c8c9-5887-43e4-905d-6f513d755484', '2025-08-14T07:13:55.238084+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'a592c8c9-5887-43e4-905d-6f513d755484');

-- ensure reservation for 93ca0d8e-a697-4c6f-a814-fb8d87843acb
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '93ca0d8e-a697-4c6f-a814-fb8d87843acb', 'd32f13f7-828d-4a67-81ef-6b4ec81dbe65', '827101b4-4efe-4af7-8083-cfcb68d23237', 'car', 'confirmed', '2025-08-14T07:13:54.643159+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '93ca0d8e-a697-4c6f-a814-fb8d87843acb');
UPDATE reservation SET re_quote_id = '827101b4-4efe-4af7-8083-cfcb68d23237', re_type = 'car'
WHERE re_id = '93ca0d8e-a697-4c6f-a814-fb8d87843acb' AND (re_quote_id IS DISTINCT FROM '827101b4-4efe-4af7-8083-cfcb68d23237' OR re_type <> 'car');
-- reservation_cruise_car for reservation 93ca0d8e-a697-4c6f-a814-fb8d87843acb
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '93ca0d8e-a697-4c6f-a814-fb8d87843acb', '2025-08-14T07:13:54.643159+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '93ca0d8e-a697-4c6f-a814-fb8d87843acb');

-- ensure reservation for ef7ebe40-50bf-4bc1-beb7-b250ef7f5f4a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'ef7ebe40-50bf-4bc1-beb7-b250ef7f5f4a', '286ace28-ee82-4a24-b6d8-8be344554f55', '38819429-bbb5-40b8-9a38-cac5f4feda63', 'car', 'confirmed', '2025-08-14T07:13:54.002433+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'ef7ebe40-50bf-4bc1-beb7-b250ef7f5f4a');
UPDATE reservation SET re_quote_id = '38819429-bbb5-40b8-9a38-cac5f4feda63', re_type = 'car'
WHERE re_id = 'ef7ebe40-50bf-4bc1-beb7-b250ef7f5f4a' AND (re_quote_id IS DISTINCT FROM '38819429-bbb5-40b8-9a38-cac5f4feda63' OR re_type <> 'car');
-- reservation_cruise_car for reservation ef7ebe40-50bf-4bc1-beb7-b250ef7f5f4a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'ef7ebe40-50bf-4bc1-beb7-b250ef7f5f4a', '2025-08-14T07:13:54.002433+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'ef7ebe40-50bf-4bc1-beb7-b250ef7f5f4a');

-- ensure reservation for 39e444f1-0612-48ff-a508-cb0392935448
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '39e444f1-0612-48ff-a508-cb0392935448', 'bf3ebebc-85a7-47ac-a845-f3dafbda5976', '5d83d8b2-c1f7-411d-b1d6-e6e47d51d898', 'car', 'confirmed', '2025-08-14T07:13:53.416341+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '39e444f1-0612-48ff-a508-cb0392935448');
UPDATE reservation SET re_quote_id = '5d83d8b2-c1f7-411d-b1d6-e6e47d51d898', re_type = 'car'
WHERE re_id = '39e444f1-0612-48ff-a508-cb0392935448' AND (re_quote_id IS DISTINCT FROM '5d83d8b2-c1f7-411d-b1d6-e6e47d51d898' OR re_type <> 'car');
-- reservation_cruise_car for reservation 39e444f1-0612-48ff-a508-cb0392935448
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '39e444f1-0612-48ff-a508-cb0392935448', '2025-08-14T07:13:53.416341+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '39e444f1-0612-48ff-a508-cb0392935448');

-- ensure reservation for 0e4f88a7-8a1e-4164-9403-3ce17778c83a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0e4f88a7-8a1e-4164-9403-3ce17778c83a', 'd743f032-573c-41e6-873d-7cb039e4f594', 'a98e2d9e-7d45-4db2-b740-7dd5da6c371a', 'car', 'confirmed', '2025-08-14T07:13:47.833707+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0e4f88a7-8a1e-4164-9403-3ce17778c83a');
UPDATE reservation SET re_quote_id = 'a98e2d9e-7d45-4db2-b740-7dd5da6c371a', re_type = 'car'
WHERE re_id = '0e4f88a7-8a1e-4164-9403-3ce17778c83a' AND (re_quote_id IS DISTINCT FROM 'a98e2d9e-7d45-4db2-b740-7dd5da6c371a' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0e4f88a7-8a1e-4164-9403-3ce17778c83a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0e4f88a7-8a1e-4164-9403-3ce17778c83a', '2025-08-14T07:13:47.833707+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0e4f88a7-8a1e-4164-9403-3ce17778c83a');

COMMIT;
