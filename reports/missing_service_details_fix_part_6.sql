-- Auto-generated SQL to insert minimal missing service-detail rows
-- Review carefully before running. This script uses re_created_at as a fallback datetime where explicit service dates are absent.
-- Run in a transaction and/or on a replica for verification.

BEGIN;

-- ensure reservation for 8da5a3ee-df20-48ee-a209-c1ddfc883941
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '8da5a3ee-df20-48ee-a209-c1ddfc883941', 'cb8cff84-2cbe-424e-b960-a976cf6e7fa0', 'bd8d959e-1c92-48cc-93a0-5d58f8e9c66c', 'car', 'confirmed', '2025-08-14T07:13:45.946608+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '8da5a3ee-df20-48ee-a209-c1ddfc883941');
UPDATE reservation SET re_quote_id = 'bd8d959e-1c92-48cc-93a0-5d58f8e9c66c', re_type = 'car'
WHERE re_id = '8da5a3ee-df20-48ee-a209-c1ddfc883941' AND (re_quote_id IS DISTINCT FROM 'bd8d959e-1c92-48cc-93a0-5d58f8e9c66c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 8da5a3ee-df20-48ee-a209-c1ddfc883941
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '8da5a3ee-df20-48ee-a209-c1ddfc883941', '2025-08-14T07:13:45.946608+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '8da5a3ee-df20-48ee-a209-c1ddfc883941');

-- ensure reservation for 656306de-2dac-419f-b46d-249ed6aeae3a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '656306de-2dac-419f-b46d-249ed6aeae3a', '54083298-111a-4129-85e0-99367af6763f', '0f1888d8-6ddb-49e6-9d62-961363b98bf8', 'car', 'confirmed', '2025-08-14T07:13:43.053036+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '656306de-2dac-419f-b46d-249ed6aeae3a');
UPDATE reservation SET re_quote_id = '0f1888d8-6ddb-49e6-9d62-961363b98bf8', re_type = 'car'
WHERE re_id = '656306de-2dac-419f-b46d-249ed6aeae3a' AND (re_quote_id IS DISTINCT FROM '0f1888d8-6ddb-49e6-9d62-961363b98bf8' OR re_type <> 'car');
-- reservation_cruise_car for reservation 656306de-2dac-419f-b46d-249ed6aeae3a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '656306de-2dac-419f-b46d-249ed6aeae3a', '2025-08-14T07:13:43.053036+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '656306de-2dac-419f-b46d-249ed6aeae3a');

-- ensure reservation for 1f5ea56c-1572-414d-884b-a0713e05046e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1f5ea56c-1572-414d-884b-a0713e05046e', '2e5b98bf-9b0b-46e0-99d7-b155b0c3de62', 'c41e2698-727d-4854-a568-d41136de9bd5', 'car', 'confirmed', '2025-08-14T07:13:39.982895+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1f5ea56c-1572-414d-884b-a0713e05046e');
UPDATE reservation SET re_quote_id = 'c41e2698-727d-4854-a568-d41136de9bd5', re_type = 'car'
WHERE re_id = '1f5ea56c-1572-414d-884b-a0713e05046e' AND (re_quote_id IS DISTINCT FROM 'c41e2698-727d-4854-a568-d41136de9bd5' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1f5ea56c-1572-414d-884b-a0713e05046e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1f5ea56c-1572-414d-884b-a0713e05046e', '2025-08-14T07:13:39.982895+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1f5ea56c-1572-414d-884b-a0713e05046e');

-- ensure reservation for 253560c3-8cdc-4e9f-bae3-b7365d352b87
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '253560c3-8cdc-4e9f-bae3-b7365d352b87', '7b4a2a2c-6d33-4757-8c23-2304ebacfcf4', '57a333d5-5159-48d4-8b05-4206a30bda41', 'car', 'confirmed', '2025-08-14T07:13:38.874214+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '253560c3-8cdc-4e9f-bae3-b7365d352b87');
UPDATE reservation SET re_quote_id = '57a333d5-5159-48d4-8b05-4206a30bda41', re_type = 'car'
WHERE re_id = '253560c3-8cdc-4e9f-bae3-b7365d352b87' AND (re_quote_id IS DISTINCT FROM '57a333d5-5159-48d4-8b05-4206a30bda41' OR re_type <> 'car');
-- reservation_cruise_car for reservation 253560c3-8cdc-4e9f-bae3-b7365d352b87
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '253560c3-8cdc-4e9f-bae3-b7365d352b87', '2025-08-14T07:13:38.874214+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '253560c3-8cdc-4e9f-bae3-b7365d352b87');

-- ensure reservation for 4c4b1d75-0647-4962-9e28-05edc1400231
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '4c4b1d75-0647-4962-9e28-05edc1400231', '54083298-111a-4129-85e0-99367af6763f', '0f1888d8-6ddb-49e6-9d62-961363b98bf8', 'car', 'confirmed', '2025-08-14T07:13:38.273317+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '4c4b1d75-0647-4962-9e28-05edc1400231');
UPDATE reservation SET re_quote_id = '0f1888d8-6ddb-49e6-9d62-961363b98bf8', re_type = 'car'
WHERE re_id = '4c4b1d75-0647-4962-9e28-05edc1400231' AND (re_quote_id IS DISTINCT FROM '0f1888d8-6ddb-49e6-9d62-961363b98bf8' OR re_type <> 'car');
-- reservation_cruise_car for reservation 4c4b1d75-0647-4962-9e28-05edc1400231
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '4c4b1d75-0647-4962-9e28-05edc1400231', '2025-08-14T07:13:38.273317+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '4c4b1d75-0647-4962-9e28-05edc1400231');

-- ensure reservation for 19e5c0d3-eb37-4f63-9946-c0183f8c40b2
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '19e5c0d3-eb37-4f63-9946-c0183f8c40b2', '7070cf9f-3dbe-4c8d-a86b-4c7660a8a1c7', 'accc5820-aae6-4372-b4cc-a08701cdb093', 'car', 'confirmed', '2025-08-14T07:13:36.509732+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '19e5c0d3-eb37-4f63-9946-c0183f8c40b2');
UPDATE reservation SET re_quote_id = 'accc5820-aae6-4372-b4cc-a08701cdb093', re_type = 'car'
WHERE re_id = '19e5c0d3-eb37-4f63-9946-c0183f8c40b2' AND (re_quote_id IS DISTINCT FROM 'accc5820-aae6-4372-b4cc-a08701cdb093' OR re_type <> 'car');
-- reservation_cruise_car for reservation 19e5c0d3-eb37-4f63-9946-c0183f8c40b2
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '19e5c0d3-eb37-4f63-9946-c0183f8c40b2', '2025-08-14T07:13:36.509732+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '19e5c0d3-eb37-4f63-9946-c0183f8c40b2');

-- ensure reservation for c6ffc44e-b94d-4257-be82-4919765c3a02
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c6ffc44e-b94d-4257-be82-4919765c3a02', '01848256-52b0-4ce6-9a21-ad2f8b5ff10c', '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79', 'car', 'confirmed', '2025-08-14T07:13:33.012198+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c6ffc44e-b94d-4257-be82-4919765c3a02');
UPDATE reservation SET re_quote_id = '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79', re_type = 'car'
WHERE re_id = 'c6ffc44e-b94d-4257-be82-4919765c3a02' AND (re_quote_id IS DISTINCT FROM '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79' OR re_type <> 'car');
-- reservation_cruise_car for reservation c6ffc44e-b94d-4257-be82-4919765c3a02
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c6ffc44e-b94d-4257-be82-4919765c3a02', '2025-08-14T07:13:33.012198+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c6ffc44e-b94d-4257-be82-4919765c3a02');

-- ensure reservation for 402c2f0f-578e-45ed-9577-6a68838f7e77
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '402c2f0f-578e-45ed-9577-6a68838f7e77', '01848256-52b0-4ce6-9a21-ad2f8b5ff10c', '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79', 'car', 'confirmed', '2025-08-14T07:13:32.436434+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '402c2f0f-578e-45ed-9577-6a68838f7e77');
UPDATE reservation SET re_quote_id = '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79', re_type = 'car'
WHERE re_id = '402c2f0f-578e-45ed-9577-6a68838f7e77' AND (re_quote_id IS DISTINCT FROM '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79' OR re_type <> 'car');
-- reservation_cruise_car for reservation 402c2f0f-578e-45ed-9577-6a68838f7e77
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '402c2f0f-578e-45ed-9577-6a68838f7e77', '2025-08-14T07:13:32.436434+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '402c2f0f-578e-45ed-9577-6a68838f7e77');

-- ensure reservation for b87997a0-3e80-43c7-b8c7-c53e8fe2e0a1
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'b87997a0-3e80-43c7-b8c7-c53e8fe2e0a1', '37b1ee61-4f0b-4768-a867-92a9e67996fd', '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', 'car', 'confirmed', '2025-08-14T07:13:31.824205+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'b87997a0-3e80-43c7-b8c7-c53e8fe2e0a1');
UPDATE reservation SET re_quote_id = '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7', re_type = 'car'
WHERE re_id = 'b87997a0-3e80-43c7-b8c7-c53e8fe2e0a1' AND (re_quote_id IS DISTINCT FROM '1a3ae118-5909-4b5e-82b9-0c7c6f5009d7' OR re_type <> 'car');
-- reservation_cruise_car for reservation b87997a0-3e80-43c7-b8c7-c53e8fe2e0a1
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'b87997a0-3e80-43c7-b8c7-c53e8fe2e0a1', '2025-08-14T07:13:31.824205+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'b87997a0-3e80-43c7-b8c7-c53e8fe2e0a1');

-- ensure reservation for 06b18f8c-d89d-4324-ac7c-f409db26131c
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '06b18f8c-d89d-4324-ac7c-f409db26131c', '01848256-52b0-4ce6-9a21-ad2f8b5ff10c', '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79', 'car', 'confirmed', '2025-08-14T07:13:31.227373+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '06b18f8c-d89d-4324-ac7c-f409db26131c');
UPDATE reservation SET re_quote_id = '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79', re_type = 'car'
WHERE re_id = '06b18f8c-d89d-4324-ac7c-f409db26131c' AND (re_quote_id IS DISTINCT FROM '94091805-9a2f-4c9c-b3a1-0ff9eeeabe79' OR re_type <> 'car');
-- reservation_cruise_car for reservation 06b18f8c-d89d-4324-ac7c-f409db26131c
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '06b18f8c-d89d-4324-ac7c-f409db26131c', '2025-08-14T07:13:31.227373+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '06b18f8c-d89d-4324-ac7c-f409db26131c');

-- ensure reservation for 415fa12b-499f-45e4-8bdd-9e41353e2059
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '415fa12b-499f-45e4-8bdd-9e41353e2059', '584ee793-9ce7-4b2b-adcb-8713b5b0a395', '073d0b74-574f-4e78-9827-a588808bde61', 'car', 'confirmed', '2025-08-14T07:13:28.206955+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '415fa12b-499f-45e4-8bdd-9e41353e2059');
UPDATE reservation SET re_quote_id = '073d0b74-574f-4e78-9827-a588808bde61', re_type = 'car'
WHERE re_id = '415fa12b-499f-45e4-8bdd-9e41353e2059' AND (re_quote_id IS DISTINCT FROM '073d0b74-574f-4e78-9827-a588808bde61' OR re_type <> 'car');
-- reservation_cruise_car for reservation 415fa12b-499f-45e4-8bdd-9e41353e2059
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '415fa12b-499f-45e4-8bdd-9e41353e2059', '2025-08-14T07:13:28.206955+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '415fa12b-499f-45e4-8bdd-9e41353e2059');

-- ensure reservation for 6713bc02-f28e-4b3b-bd83-05ec4434da30
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '6713bc02-f28e-4b3b-bd83-05ec4434da30', '584ee793-9ce7-4b2b-adcb-8713b5b0a395', '073d0b74-574f-4e78-9827-a588808bde61', 'car', 'confirmed', '2025-08-14T07:13:27.5452+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '6713bc02-f28e-4b3b-bd83-05ec4434da30');
UPDATE reservation SET re_quote_id = '073d0b74-574f-4e78-9827-a588808bde61', re_type = 'car'
WHERE re_id = '6713bc02-f28e-4b3b-bd83-05ec4434da30' AND (re_quote_id IS DISTINCT FROM '073d0b74-574f-4e78-9827-a588808bde61' OR re_type <> 'car');
-- reservation_cruise_car for reservation 6713bc02-f28e-4b3b-bd83-05ec4434da30
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '6713bc02-f28e-4b3b-bd83-05ec4434da30', '2025-08-14T07:13:27.5452+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '6713bc02-f28e-4b3b-bd83-05ec4434da30');

-- ensure reservation for 9ffa6d1c-16cd-4f5a-812c-2406ab21a280
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '9ffa6d1c-16cd-4f5a-812c-2406ab21a280', '380a923b-ce1f-4305-9dbe-82a4e8e552bb', 'ebcb3452-e248-4a5f-aa6b-df68b878ee50', 'car', 'confirmed', '2025-08-14T07:13:26.921103+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '9ffa6d1c-16cd-4f5a-812c-2406ab21a280');
UPDATE reservation SET re_quote_id = 'ebcb3452-e248-4a5f-aa6b-df68b878ee50', re_type = 'car'
WHERE re_id = '9ffa6d1c-16cd-4f5a-812c-2406ab21a280' AND (re_quote_id IS DISTINCT FROM 'ebcb3452-e248-4a5f-aa6b-df68b878ee50' OR re_type <> 'car');
-- reservation_cruise_car for reservation 9ffa6d1c-16cd-4f5a-812c-2406ab21a280
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '9ffa6d1c-16cd-4f5a-812c-2406ab21a280', '2025-08-14T07:13:26.921103+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '9ffa6d1c-16cd-4f5a-812c-2406ab21a280');

-- ensure reservation for 786d651b-1364-4222-88e8-02dbd15e32dd
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '786d651b-1364-4222-88e8-02dbd15e32dd', 'a5beb1c7-9abb-4c24-b58c-7237595329f7', '5abedf46-53ed-4e1b-b1ae-f0118a86fda9', 'car', 'confirmed', '2025-08-14T07:13:22.056878+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '786d651b-1364-4222-88e8-02dbd15e32dd');
UPDATE reservation SET re_quote_id = '5abedf46-53ed-4e1b-b1ae-f0118a86fda9', re_type = 'car'
WHERE re_id = '786d651b-1364-4222-88e8-02dbd15e32dd' AND (re_quote_id IS DISTINCT FROM '5abedf46-53ed-4e1b-b1ae-f0118a86fda9' OR re_type <> 'car');
-- reservation_cruise_car for reservation 786d651b-1364-4222-88e8-02dbd15e32dd
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '786d651b-1364-4222-88e8-02dbd15e32dd', '2025-08-14T07:13:22.056878+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '786d651b-1364-4222-88e8-02dbd15e32dd');

-- ensure reservation for 8c08cd0b-1de9-489e-be57-a9ea393bb6f9
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '8c08cd0b-1de9-489e-be57-a9ea393bb6f9', '8fa80f2a-ae58-47f7-829e-99c2aed63a3a', '0f6f7cd7-15df-470b-8311-fe3ec52697e5', 'car', 'confirmed', '2025-08-14T07:13:19.655317+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '8c08cd0b-1de9-489e-be57-a9ea393bb6f9');
UPDATE reservation SET re_quote_id = '0f6f7cd7-15df-470b-8311-fe3ec52697e5', re_type = 'car'
WHERE re_id = '8c08cd0b-1de9-489e-be57-a9ea393bb6f9' AND (re_quote_id IS DISTINCT FROM '0f6f7cd7-15df-470b-8311-fe3ec52697e5' OR re_type <> 'car');
-- reservation_cruise_car for reservation 8c08cd0b-1de9-489e-be57-a9ea393bb6f9
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '8c08cd0b-1de9-489e-be57-a9ea393bb6f9', '2025-08-14T07:13:19.655317+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '8c08cd0b-1de9-489e-be57-a9ea393bb6f9');

-- ensure reservation for 1366cfc0-9a3a-4612-b67d-fa2430388d6a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1366cfc0-9a3a-4612-b67d-fa2430388d6a', '28c19b88-35fd-45bf-8ada-fa2a32c276e2', '24c5515f-146a-4145-91c5-f367ae9399ab', 'car', 'confirmed', '2025-08-14T07:13:16.595944+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1366cfc0-9a3a-4612-b67d-fa2430388d6a');
UPDATE reservation SET re_quote_id = '24c5515f-146a-4145-91c5-f367ae9399ab', re_type = 'car'
WHERE re_id = '1366cfc0-9a3a-4612-b67d-fa2430388d6a' AND (re_quote_id IS DISTINCT FROM '24c5515f-146a-4145-91c5-f367ae9399ab' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1366cfc0-9a3a-4612-b67d-fa2430388d6a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1366cfc0-9a3a-4612-b67d-fa2430388d6a', '2025-08-14T07:13:16.595944+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1366cfc0-9a3a-4612-b67d-fa2430388d6a');

-- ensure reservation for 73f2cbaa-fd5b-443e-9eb5-282aa372f44b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '73f2cbaa-fd5b-443e-9eb5-282aa372f44b', '411f5a24-8a3c-4d4b-b9d4-d9df68e6c4bf', '41980e69-df96-4866-9cca-ae693263e1f5', 'car', 'confirmed', '2025-08-14T07:13:12.562848+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '73f2cbaa-fd5b-443e-9eb5-282aa372f44b');
UPDATE reservation SET re_quote_id = '41980e69-df96-4866-9cca-ae693263e1f5', re_type = 'car'
WHERE re_id = '73f2cbaa-fd5b-443e-9eb5-282aa372f44b' AND (re_quote_id IS DISTINCT FROM '41980e69-df96-4866-9cca-ae693263e1f5' OR re_type <> 'car');
-- reservation_cruise_car for reservation 73f2cbaa-fd5b-443e-9eb5-282aa372f44b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '73f2cbaa-fd5b-443e-9eb5-282aa372f44b', '2025-08-14T07:13:12.562848+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '73f2cbaa-fd5b-443e-9eb5-282aa372f44b');

-- ensure reservation for 34d83cf4-e401-4dff-b094-c6295e8c16d9
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '34d83cf4-e401-4dff-b094-c6295e8c16d9', '61e94b26-836b-4bd5-896b-d8ba6206af2e', '2893aeeb-40bc-4a3f-a946-f49bd3abc4e1', 'car', 'confirmed', '2025-08-14T07:13:11.304002+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '34d83cf4-e401-4dff-b094-c6295e8c16d9');
UPDATE reservation SET re_quote_id = '2893aeeb-40bc-4a3f-a946-f49bd3abc4e1', re_type = 'car'
WHERE re_id = '34d83cf4-e401-4dff-b094-c6295e8c16d9' AND (re_quote_id IS DISTINCT FROM '2893aeeb-40bc-4a3f-a946-f49bd3abc4e1' OR re_type <> 'car');
-- reservation_cruise_car for reservation 34d83cf4-e401-4dff-b094-c6295e8c16d9
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '34d83cf4-e401-4dff-b094-c6295e8c16d9', '2025-08-14T07:13:11.304002+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '34d83cf4-e401-4dff-b094-c6295e8c16d9');

-- ensure reservation for 201d53ac-fbee-4b23-8afe-3434ac2068f9
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '201d53ac-fbee-4b23-8afe-3434ac2068f9', '61e94b26-836b-4bd5-896b-d8ba6206af2e', '2893aeeb-40bc-4a3f-a946-f49bd3abc4e1', 'car', 'confirmed', '2025-08-14T07:13:10.674324+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '201d53ac-fbee-4b23-8afe-3434ac2068f9');
UPDATE reservation SET re_quote_id = '2893aeeb-40bc-4a3f-a946-f49bd3abc4e1', re_type = 'car'
WHERE re_id = '201d53ac-fbee-4b23-8afe-3434ac2068f9' AND (re_quote_id IS DISTINCT FROM '2893aeeb-40bc-4a3f-a946-f49bd3abc4e1' OR re_type <> 'car');
-- reservation_cruise_car for reservation 201d53ac-fbee-4b23-8afe-3434ac2068f9
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '201d53ac-fbee-4b23-8afe-3434ac2068f9', '2025-08-14T07:13:10.674324+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '201d53ac-fbee-4b23-8afe-3434ac2068f9');

-- ensure reservation for d78bacb5-ed9f-40fa-849f-d41c1d0e5380
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'd78bacb5-ed9f-40fa-849f-d41c1d0e5380', '6c93b92c-9c50-4fd7-a929-e5b11adcba91', '9ab95fb7-395b-4b92-94a2-e2fe90fcaf43', 'car', 'confirmed', '2025-08-14T07:13:08.985082+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'd78bacb5-ed9f-40fa-849f-d41c1d0e5380');
UPDATE reservation SET re_quote_id = '9ab95fb7-395b-4b92-94a2-e2fe90fcaf43', re_type = 'car'
WHERE re_id = 'd78bacb5-ed9f-40fa-849f-d41c1d0e5380' AND (re_quote_id IS DISTINCT FROM '9ab95fb7-395b-4b92-94a2-e2fe90fcaf43' OR re_type <> 'car');
-- reservation_cruise_car for reservation d78bacb5-ed9f-40fa-849f-d41c1d0e5380
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'd78bacb5-ed9f-40fa-849f-d41c1d0e5380', '2025-08-14T07:13:08.985082+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'd78bacb5-ed9f-40fa-849f-d41c1d0e5380');

-- ensure reservation for c5ce7130-f2f1-434c-baf0-e1b5c062f1f4
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c5ce7130-f2f1-434c-baf0-e1b5c062f1f4', 'a1cf4db9-dde1-4fd4-a0ab-4f6d3b55fdca', 'c343ca01-b66d-4dfb-bca5-ef2b06345e89', 'car', 'confirmed', '2025-08-14T07:13:07.846925+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c5ce7130-f2f1-434c-baf0-e1b5c062f1f4');
UPDATE reservation SET re_quote_id = 'c343ca01-b66d-4dfb-bca5-ef2b06345e89', re_type = 'car'
WHERE re_id = 'c5ce7130-f2f1-434c-baf0-e1b5c062f1f4' AND (re_quote_id IS DISTINCT FROM 'c343ca01-b66d-4dfb-bca5-ef2b06345e89' OR re_type <> 'car');
-- reservation_cruise_car for reservation c5ce7130-f2f1-434c-baf0-e1b5c062f1f4
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c5ce7130-f2f1-434c-baf0-e1b5c062f1f4', '2025-08-14T07:13:07.846925+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c5ce7130-f2f1-434c-baf0-e1b5c062f1f4');

-- ensure reservation for 2ec04e81-dc4c-4c1a-aec0-ef95644c1959
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2ec04e81-dc4c-4c1a-aec0-ef95644c1959', '55f4aadf-9ab8-4d2d-9a84-df87214fe3d2', '82e607e9-65d2-4eb9-a204-0ae9382b18b5', 'car', 'confirmed', '2025-08-14T07:13:07.32578+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2ec04e81-dc4c-4c1a-aec0-ef95644c1959');
UPDATE reservation SET re_quote_id = '82e607e9-65d2-4eb9-a204-0ae9382b18b5', re_type = 'car'
WHERE re_id = '2ec04e81-dc4c-4c1a-aec0-ef95644c1959' AND (re_quote_id IS DISTINCT FROM '82e607e9-65d2-4eb9-a204-0ae9382b18b5' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2ec04e81-dc4c-4c1a-aec0-ef95644c1959
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2ec04e81-dc4c-4c1a-aec0-ef95644c1959', '2025-08-14T07:13:07.32578+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2ec04e81-dc4c-4c1a-aec0-ef95644c1959');

-- ensure reservation for fe56f26f-5672-4d54-9f46-f90ad5a33380
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'fe56f26f-5672-4d54-9f46-f90ad5a33380', '70849874-1259-4308-b597-2baabc1f9af8', '9c2ca8fc-8f60-47e4-bb58-09295b705189', 'car', 'confirmed', '2025-08-14T07:13:04.92886+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'fe56f26f-5672-4d54-9f46-f90ad5a33380');
UPDATE reservation SET re_quote_id = '9c2ca8fc-8f60-47e4-bb58-09295b705189', re_type = 'car'
WHERE re_id = 'fe56f26f-5672-4d54-9f46-f90ad5a33380' AND (re_quote_id IS DISTINCT FROM '9c2ca8fc-8f60-47e4-bb58-09295b705189' OR re_type <> 'car');
-- reservation_cruise_car for reservation fe56f26f-5672-4d54-9f46-f90ad5a33380
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'fe56f26f-5672-4d54-9f46-f90ad5a33380', '2025-08-14T07:13:04.92886+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'fe56f26f-5672-4d54-9f46-f90ad5a33380');

-- ensure reservation for 2518eee1-604e-4996-bcde-845e8f6ffb2d
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2518eee1-604e-4996-bcde-845e8f6ffb2d', '5217cd4e-54ca-4eb3-a634-df680c268f6f', '60ffeb3a-9248-44b0-90f1-dbd1d9a6db2e', 'car', 'confirmed', '2025-08-14T07:13:04.406067+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2518eee1-604e-4996-bcde-845e8f6ffb2d');
UPDATE reservation SET re_quote_id = '60ffeb3a-9248-44b0-90f1-dbd1d9a6db2e', re_type = 'car'
WHERE re_id = '2518eee1-604e-4996-bcde-845e8f6ffb2d' AND (re_quote_id IS DISTINCT FROM '60ffeb3a-9248-44b0-90f1-dbd1d9a6db2e' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2518eee1-604e-4996-bcde-845e8f6ffb2d
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2518eee1-604e-4996-bcde-845e8f6ffb2d', '2025-08-14T07:13:04.406067+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2518eee1-604e-4996-bcde-845e8f6ffb2d');

-- ensure reservation for 08780653-944e-4b6e-8a86-661a315560b0
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '08780653-944e-4b6e-8a86-661a315560b0', '3e9e07be-3b01-4240-9fee-5f07950cfd68', '556a1759-398b-45b3-9581-0d0b9417410c', 'car', 'confirmed', '2025-08-14T07:12:58.832259+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '08780653-944e-4b6e-8a86-661a315560b0');
UPDATE reservation SET re_quote_id = '556a1759-398b-45b3-9581-0d0b9417410c', re_type = 'car'
WHERE re_id = '08780653-944e-4b6e-8a86-661a315560b0' AND (re_quote_id IS DISTINCT FROM '556a1759-398b-45b3-9581-0d0b9417410c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 08780653-944e-4b6e-8a86-661a315560b0
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '08780653-944e-4b6e-8a86-661a315560b0', '2025-08-14T07:12:58.832259+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '08780653-944e-4b6e-8a86-661a315560b0');

-- ensure reservation for ed18e721-5db6-4b5f-85fe-a5d8e91ee49e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'ed18e721-5db6-4b5f-85fe-a5d8e91ee49e', '3f5fd3f0-adca-4adb-903d-c7fe80778090', '0fe593b2-58c8-4a89-b91e-d1c73cb41ded', 'car', 'confirmed', '2025-08-14T07:12:58.235067+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'ed18e721-5db6-4b5f-85fe-a5d8e91ee49e');
UPDATE reservation SET re_quote_id = '0fe593b2-58c8-4a89-b91e-d1c73cb41ded', re_type = 'car'
WHERE re_id = 'ed18e721-5db6-4b5f-85fe-a5d8e91ee49e' AND (re_quote_id IS DISTINCT FROM '0fe593b2-58c8-4a89-b91e-d1c73cb41ded' OR re_type <> 'car');
-- reservation_cruise_car for reservation ed18e721-5db6-4b5f-85fe-a5d8e91ee49e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'ed18e721-5db6-4b5f-85fe-a5d8e91ee49e', '2025-08-14T07:12:58.235067+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'ed18e721-5db6-4b5f-85fe-a5d8e91ee49e');

-- ensure reservation for a57a8c38-ac39-4059-affd-10630e69fc1e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'a57a8c38-ac39-4059-affd-10630e69fc1e', '62e9b586-76a8-4d75-a2ca-fafb0b16ed0d', 'ae5faad4-bf37-4f53-9a55-3d50c0313dec', 'car', 'confirmed', '2025-08-14T07:12:55.125882+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'a57a8c38-ac39-4059-affd-10630e69fc1e');
UPDATE reservation SET re_quote_id = 'ae5faad4-bf37-4f53-9a55-3d50c0313dec', re_type = 'car'
WHERE re_id = 'a57a8c38-ac39-4059-affd-10630e69fc1e' AND (re_quote_id IS DISTINCT FROM 'ae5faad4-bf37-4f53-9a55-3d50c0313dec' OR re_type <> 'car');
-- reservation_cruise_car for reservation a57a8c38-ac39-4059-affd-10630e69fc1e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'a57a8c38-ac39-4059-affd-10630e69fc1e', '2025-08-14T07:12:55.125882+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'a57a8c38-ac39-4059-affd-10630e69fc1e');

-- ensure reservation for 5e190bbe-325d-4518-9060-55e6326568c5
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '5e190bbe-325d-4518-9060-55e6326568c5', '32fc223a-b652-462e-bc7f-09ff096c080f', 'a6cf54fd-50d4-493e-abe7-71c91e6f2594', 'car', 'confirmed', '2025-08-14T07:12:54.523398+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '5e190bbe-325d-4518-9060-55e6326568c5');
UPDATE reservation SET re_quote_id = 'a6cf54fd-50d4-493e-abe7-71c91e6f2594', re_type = 'car'
WHERE re_id = '5e190bbe-325d-4518-9060-55e6326568c5' AND (re_quote_id IS DISTINCT FROM 'a6cf54fd-50d4-493e-abe7-71c91e6f2594' OR re_type <> 'car');
-- reservation_cruise_car for reservation 5e190bbe-325d-4518-9060-55e6326568c5
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '5e190bbe-325d-4518-9060-55e6326568c5', '2025-08-14T07:12:54.523398+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '5e190bbe-325d-4518-9060-55e6326568c5');

-- ensure reservation for 96c2294c-c84e-4cda-984e-ad546e71305c
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '96c2294c-c84e-4cda-984e-ad546e71305c', '62e9b586-76a8-4d75-a2ca-fafb0b16ed0d', 'ae5faad4-bf37-4f53-9a55-3d50c0313dec', 'car', 'confirmed', '2025-08-14T07:12:53.986136+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '96c2294c-c84e-4cda-984e-ad546e71305c');
UPDATE reservation SET re_quote_id = 'ae5faad4-bf37-4f53-9a55-3d50c0313dec', re_type = 'car'
WHERE re_id = '96c2294c-c84e-4cda-984e-ad546e71305c' AND (re_quote_id IS DISTINCT FROM 'ae5faad4-bf37-4f53-9a55-3d50c0313dec' OR re_type <> 'car');
-- reservation_cruise_car for reservation 96c2294c-c84e-4cda-984e-ad546e71305c
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '96c2294c-c84e-4cda-984e-ad546e71305c', '2025-08-14T07:12:53.986136+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '96c2294c-c84e-4cda-984e-ad546e71305c');

-- ensure reservation for 96746f50-8547-4bbd-9e45-0a5a0a66a429
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '96746f50-8547-4bbd-9e45-0a5a0a66a429', '4f0cbaf2-0fe1-4df3-b9c6-83d12f2d7070', '6f0ed3c8-42f5-427d-908e-2985507af401', 'car', 'confirmed', '2025-08-14T07:12:53.392573+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '96746f50-8547-4bbd-9e45-0a5a0a66a429');
UPDATE reservation SET re_quote_id = '6f0ed3c8-42f5-427d-908e-2985507af401', re_type = 'car'
WHERE re_id = '96746f50-8547-4bbd-9e45-0a5a0a66a429' AND (re_quote_id IS DISTINCT FROM '6f0ed3c8-42f5-427d-908e-2985507af401' OR re_type <> 'car');
-- reservation_cruise_car for reservation 96746f50-8547-4bbd-9e45-0a5a0a66a429
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '96746f50-8547-4bbd-9e45-0a5a0a66a429', '2025-08-14T07:12:53.392573+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '96746f50-8547-4bbd-9e45-0a5a0a66a429');

-- ensure reservation for 3afd52e8-b6ce-4c91-a214-52dc473cd3b2
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3afd52e8-b6ce-4c91-a214-52dc473cd3b2', '8e46f125-038f-488b-b715-9326cf3f1d71', 'a219a7ed-b32a-4b2a-a95a-7c18983c8ce1', 'car', 'confirmed', '2025-08-14T07:12:51.084269+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3afd52e8-b6ce-4c91-a214-52dc473cd3b2');
UPDATE reservation SET re_quote_id = 'a219a7ed-b32a-4b2a-a95a-7c18983c8ce1', re_type = 'car'
WHERE re_id = '3afd52e8-b6ce-4c91-a214-52dc473cd3b2' AND (re_quote_id IS DISTINCT FROM 'a219a7ed-b32a-4b2a-a95a-7c18983c8ce1' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3afd52e8-b6ce-4c91-a214-52dc473cd3b2
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3afd52e8-b6ce-4c91-a214-52dc473cd3b2', '2025-08-14T07:12:51.084269+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3afd52e8-b6ce-4c91-a214-52dc473cd3b2');

-- ensure reservation for f114975d-4ec9-4c26-b15a-80cd1bec31de
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'f114975d-4ec9-4c26-b15a-80cd1bec31de', '4ce46050-a869-43f3-960e-c359703a7d59', 'c00a01bf-b7bd-4889-8461-93110e051e08', 'car', 'confirmed', '2025-08-14T07:12:50.364796+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'f114975d-4ec9-4c26-b15a-80cd1bec31de');
UPDATE reservation SET re_quote_id = 'c00a01bf-b7bd-4889-8461-93110e051e08', re_type = 'car'
WHERE re_id = 'f114975d-4ec9-4c26-b15a-80cd1bec31de' AND (re_quote_id IS DISTINCT FROM 'c00a01bf-b7bd-4889-8461-93110e051e08' OR re_type <> 'car');
-- reservation_cruise_car for reservation f114975d-4ec9-4c26-b15a-80cd1bec31de
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'f114975d-4ec9-4c26-b15a-80cd1bec31de', '2025-08-14T07:12:50.364796+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'f114975d-4ec9-4c26-b15a-80cd1bec31de');

-- ensure reservation for be66a283-d2a9-41d8-b15f-3b7dc3a9bc77
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'be66a283-d2a9-41d8-b15f-3b7dc3a9bc77', '8e46f125-038f-488b-b715-9326cf3f1d71', 'a219a7ed-b32a-4b2a-a95a-7c18983c8ce1', 'car', 'confirmed', '2025-08-14T07:12:49.504544+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'be66a283-d2a9-41d8-b15f-3b7dc3a9bc77');
UPDATE reservation SET re_quote_id = 'a219a7ed-b32a-4b2a-a95a-7c18983c8ce1', re_type = 'car'
WHERE re_id = 'be66a283-d2a9-41d8-b15f-3b7dc3a9bc77' AND (re_quote_id IS DISTINCT FROM 'a219a7ed-b32a-4b2a-a95a-7c18983c8ce1' OR re_type <> 'car');
-- reservation_cruise_car for reservation be66a283-d2a9-41d8-b15f-3b7dc3a9bc77
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'be66a283-d2a9-41d8-b15f-3b7dc3a9bc77', '2025-08-14T07:12:49.504544+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'be66a283-d2a9-41d8-b15f-3b7dc3a9bc77');

-- ensure reservation for c8493134-ff62-49ae-b588-416573278a3d
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c8493134-ff62-49ae-b588-416573278a3d', 'dd7b008d-772f-4bfa-bd50-eae11192ef88', '052bfd3f-3d2e-455a-bd94-8ccb5fc87002', 'car', 'confirmed', '2025-08-14T07:12:47.664438+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c8493134-ff62-49ae-b588-416573278a3d');
UPDATE reservation SET re_quote_id = '052bfd3f-3d2e-455a-bd94-8ccb5fc87002', re_type = 'car'
WHERE re_id = 'c8493134-ff62-49ae-b588-416573278a3d' AND (re_quote_id IS DISTINCT FROM '052bfd3f-3d2e-455a-bd94-8ccb5fc87002' OR re_type <> 'car');
-- reservation_cruise_car for reservation c8493134-ff62-49ae-b588-416573278a3d
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c8493134-ff62-49ae-b588-416573278a3d', '2025-08-14T07:12:47.664438+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c8493134-ff62-49ae-b588-416573278a3d');

-- ensure reservation for bb6febaf-448a-4654-b65f-d07a4e7f5638
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'bb6febaf-448a-4654-b65f-d07a4e7f5638', 'a45c6a22-fbb7-4498-886a-8e98719c6456', '8dc2c8f8-8316-4494-803f-aecc65cbec91', 'car', 'confirmed', '2025-08-14T07:12:46.320919+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'bb6febaf-448a-4654-b65f-d07a4e7f5638');
UPDATE reservation SET re_quote_id = '8dc2c8f8-8316-4494-803f-aecc65cbec91', re_type = 'car'
WHERE re_id = 'bb6febaf-448a-4654-b65f-d07a4e7f5638' AND (re_quote_id IS DISTINCT FROM '8dc2c8f8-8316-4494-803f-aecc65cbec91' OR re_type <> 'car');
-- reservation_cruise_car for reservation bb6febaf-448a-4654-b65f-d07a4e7f5638
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'bb6febaf-448a-4654-b65f-d07a4e7f5638', '2025-08-14T07:12:46.320919+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'bb6febaf-448a-4654-b65f-d07a4e7f5638');

-- ensure reservation for 05468cf5-7200-47eb-b96f-eb9ba2ffa3f0
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '05468cf5-7200-47eb-b96f-eb9ba2ffa3f0', 'a45c6a22-fbb7-4498-886a-8e98719c6456', '8dc2c8f8-8316-4494-803f-aecc65cbec91', 'car', 'confirmed', '2025-08-14T07:12:45.73491+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '05468cf5-7200-47eb-b96f-eb9ba2ffa3f0');
UPDATE reservation SET re_quote_id = '8dc2c8f8-8316-4494-803f-aecc65cbec91', re_type = 'car'
WHERE re_id = '05468cf5-7200-47eb-b96f-eb9ba2ffa3f0' AND (re_quote_id IS DISTINCT FROM '8dc2c8f8-8316-4494-803f-aecc65cbec91' OR re_type <> 'car');
-- reservation_cruise_car for reservation 05468cf5-7200-47eb-b96f-eb9ba2ffa3f0
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '05468cf5-7200-47eb-b96f-eb9ba2ffa3f0', '2025-08-14T07:12:45.73491+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '05468cf5-7200-47eb-b96f-eb9ba2ffa3f0');

-- ensure reservation for 60ec78ef-b1ee-4868-baec-6ed3795553b2
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '60ec78ef-b1ee-4868-baec-6ed3795553b2', '2d18f15c-045c-4a03-bc3c-aac6503148da', '2d438c20-2933-4f79-8849-161ae6700ffd', 'car', 'confirmed', '2025-08-14T07:12:44.562249+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '60ec78ef-b1ee-4868-baec-6ed3795553b2');
UPDATE reservation SET re_quote_id = '2d438c20-2933-4f79-8849-161ae6700ffd', re_type = 'car'
WHERE re_id = '60ec78ef-b1ee-4868-baec-6ed3795553b2' AND (re_quote_id IS DISTINCT FROM '2d438c20-2933-4f79-8849-161ae6700ffd' OR re_type <> 'car');
-- reservation_cruise_car for reservation 60ec78ef-b1ee-4868-baec-6ed3795553b2
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '60ec78ef-b1ee-4868-baec-6ed3795553b2', '2025-08-14T07:12:44.562249+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '60ec78ef-b1ee-4868-baec-6ed3795553b2');

-- ensure reservation for f356be4f-0871-452a-9471-9096ad015a85
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'f356be4f-0871-452a-9471-9096ad015a85', 'ff5b0f6e-7889-4f81-87d3-c3c0dc6dbcab', 'a5f10076-692a-431a-9d20-077a9fa374d2', 'car', 'confirmed', '2025-08-14T07:12:43.829849+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'f356be4f-0871-452a-9471-9096ad015a85');
UPDATE reservation SET re_quote_id = 'a5f10076-692a-431a-9d20-077a9fa374d2', re_type = 'car'
WHERE re_id = 'f356be4f-0871-452a-9471-9096ad015a85' AND (re_quote_id IS DISTINCT FROM 'a5f10076-692a-431a-9d20-077a9fa374d2' OR re_type <> 'car');
-- reservation_cruise_car for reservation f356be4f-0871-452a-9471-9096ad015a85
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'f356be4f-0871-452a-9471-9096ad015a85', '2025-08-14T07:12:43.829849+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'f356be4f-0871-452a-9471-9096ad015a85');

-- ensure reservation for f91366e9-1d6d-4650-b1ea-92d1c7b6b153
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'f91366e9-1d6d-4650-b1ea-92d1c7b6b153', 'f877c891-5baa-46ad-ad59-9b588b982aae', '0a57f749-f8f6-4881-8646-43a04dbfb0c5', 'car', 'confirmed', '2025-08-14T07:12:40.768638+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'f91366e9-1d6d-4650-b1ea-92d1c7b6b153');
UPDATE reservation SET re_quote_id = '0a57f749-f8f6-4881-8646-43a04dbfb0c5', re_type = 'car'
WHERE re_id = 'f91366e9-1d6d-4650-b1ea-92d1c7b6b153' AND (re_quote_id IS DISTINCT FROM '0a57f749-f8f6-4881-8646-43a04dbfb0c5' OR re_type <> 'car');
-- reservation_cruise_car for reservation f91366e9-1d6d-4650-b1ea-92d1c7b6b153
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'f91366e9-1d6d-4650-b1ea-92d1c7b6b153', '2025-08-14T07:12:40.768638+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'f91366e9-1d6d-4650-b1ea-92d1c7b6b153');

-- ensure reservation for e8a2c40a-438c-401b-89f4-1bb137699dc3
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e8a2c40a-438c-401b-89f4-1bb137699dc3', 'cfa68832-8a32-4680-aadd-130130993c9d', 'e5827cc1-cc70-4ff5-81ab-756d5bc64018', 'car', 'confirmed', '2025-08-14T07:12:40.183145+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e8a2c40a-438c-401b-89f4-1bb137699dc3');
UPDATE reservation SET re_quote_id = 'e5827cc1-cc70-4ff5-81ab-756d5bc64018', re_type = 'car'
WHERE re_id = 'e8a2c40a-438c-401b-89f4-1bb137699dc3' AND (re_quote_id IS DISTINCT FROM 'e5827cc1-cc70-4ff5-81ab-756d5bc64018' OR re_type <> 'car');
-- reservation_cruise_car for reservation e8a2c40a-438c-401b-89f4-1bb137699dc3
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e8a2c40a-438c-401b-89f4-1bb137699dc3', '2025-08-14T07:12:40.183145+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e8a2c40a-438c-401b-89f4-1bb137699dc3');

-- ensure reservation for ecab4dd2-13f3-4a8e-9cb6-f1d1ed47f52e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'ecab4dd2-13f3-4a8e-9cb6-f1d1ed47f52e', '46409e9f-7068-4867-a9a7-13061b4848cc', '1d335d1b-b981-4b9c-90c7-5ea1d2acc7df', 'car', 'confirmed', '2025-08-14T07:12:39.611865+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'ecab4dd2-13f3-4a8e-9cb6-f1d1ed47f52e');
UPDATE reservation SET re_quote_id = '1d335d1b-b981-4b9c-90c7-5ea1d2acc7df', re_type = 'car'
WHERE re_id = 'ecab4dd2-13f3-4a8e-9cb6-f1d1ed47f52e' AND (re_quote_id IS DISTINCT FROM '1d335d1b-b981-4b9c-90c7-5ea1d2acc7df' OR re_type <> 'car');
-- reservation_cruise_car for reservation ecab4dd2-13f3-4a8e-9cb6-f1d1ed47f52e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'ecab4dd2-13f3-4a8e-9cb6-f1d1ed47f52e', '2025-08-14T07:12:39.611865+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'ecab4dd2-13f3-4a8e-9cb6-f1d1ed47f52e');

-- ensure reservation for 980660e8-1e22-43f0-9e87-dd12984bb9a0
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '980660e8-1e22-43f0-9e87-dd12984bb9a0', 'bf4e8f8c-d471-4cc9-a5bf-61fba8cda02a', 'c23e6383-bbf1-45c7-8ec6-b67af15ff097', 'car', 'confirmed', '2025-08-14T07:12:38.995654+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '980660e8-1e22-43f0-9e87-dd12984bb9a0');
UPDATE reservation SET re_quote_id = 'c23e6383-bbf1-45c7-8ec6-b67af15ff097', re_type = 'car'
WHERE re_id = '980660e8-1e22-43f0-9e87-dd12984bb9a0' AND (re_quote_id IS DISTINCT FROM 'c23e6383-bbf1-45c7-8ec6-b67af15ff097' OR re_type <> 'car');
-- reservation_cruise_car for reservation 980660e8-1e22-43f0-9e87-dd12984bb9a0
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '980660e8-1e22-43f0-9e87-dd12984bb9a0', '2025-08-14T07:12:38.995654+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '980660e8-1e22-43f0-9e87-dd12984bb9a0');

-- ensure reservation for 8d38f2ed-6028-4b55-9f5f-d20f9a273420
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '8d38f2ed-6028-4b55-9f5f-d20f9a273420', '4b0a2070-d8ec-4baf-9714-6e6c47d42110', '83b83906-3705-498b-a87d-645b66f06dc7', 'car', 'confirmed', '2025-08-14T07:12:38.386063+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '8d38f2ed-6028-4b55-9f5f-d20f9a273420');
UPDATE reservation SET re_quote_id = '83b83906-3705-498b-a87d-645b66f06dc7', re_type = 'car'
WHERE re_id = '8d38f2ed-6028-4b55-9f5f-d20f9a273420' AND (re_quote_id IS DISTINCT FROM '83b83906-3705-498b-a87d-645b66f06dc7' OR re_type <> 'car');
-- reservation_cruise_car for reservation 8d38f2ed-6028-4b55-9f5f-d20f9a273420
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '8d38f2ed-6028-4b55-9f5f-d20f9a273420', '2025-08-14T07:12:38.386063+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '8d38f2ed-6028-4b55-9f5f-d20f9a273420');

-- ensure reservation for 22eb0727-6afa-44ab-8a58-15312591c0ab
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '22eb0727-6afa-44ab-8a58-15312591c0ab', 'be8a3f5b-86b7-4cd6-b13b-9fed88feb729', '50ab3cfa-ccdc-4dd1-9071-65483979a2c9', 'car', 'confirmed', '2025-08-14T07:12:37.709598+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '22eb0727-6afa-44ab-8a58-15312591c0ab');
UPDATE reservation SET re_quote_id = '50ab3cfa-ccdc-4dd1-9071-65483979a2c9', re_type = 'car'
WHERE re_id = '22eb0727-6afa-44ab-8a58-15312591c0ab' AND (re_quote_id IS DISTINCT FROM '50ab3cfa-ccdc-4dd1-9071-65483979a2c9' OR re_type <> 'car');
-- reservation_cruise_car for reservation 22eb0727-6afa-44ab-8a58-15312591c0ab
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '22eb0727-6afa-44ab-8a58-15312591c0ab', '2025-08-14T07:12:37.709598+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '22eb0727-6afa-44ab-8a58-15312591c0ab');

-- ensure reservation for 51d55df7-ede7-4866-a017-6577746712a9
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '51d55df7-ede7-4866-a017-6577746712a9', '73325c90-41a1-487a-9424-c9569bf58e0b', '4fb7121c-dc73-4ddf-baa6-a3c80434d6ad', 'car', 'confirmed', '2025-08-14T07:12:37.097643+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '51d55df7-ede7-4866-a017-6577746712a9');
UPDATE reservation SET re_quote_id = '4fb7121c-dc73-4ddf-baa6-a3c80434d6ad', re_type = 'car'
WHERE re_id = '51d55df7-ede7-4866-a017-6577746712a9' AND (re_quote_id IS DISTINCT FROM '4fb7121c-dc73-4ddf-baa6-a3c80434d6ad' OR re_type <> 'car');
-- reservation_cruise_car for reservation 51d55df7-ede7-4866-a017-6577746712a9
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '51d55df7-ede7-4866-a017-6577746712a9', '2025-08-14T07:12:37.097643+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '51d55df7-ede7-4866-a017-6577746712a9');

-- ensure reservation for c1095e41-1a77-433e-9b26-ea016413c59e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c1095e41-1a77-433e-9b26-ea016413c59e', 'f62aced9-ae46-4f38-a618-6eb44162a844', '1f9605b2-b62b-4065-abd2-1580b76b0479', 'car', 'confirmed', '2025-08-14T07:12:36.476045+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c1095e41-1a77-433e-9b26-ea016413c59e');
UPDATE reservation SET re_quote_id = '1f9605b2-b62b-4065-abd2-1580b76b0479', re_type = 'car'
WHERE re_id = 'c1095e41-1a77-433e-9b26-ea016413c59e' AND (re_quote_id IS DISTINCT FROM '1f9605b2-b62b-4065-abd2-1580b76b0479' OR re_type <> 'car');
-- reservation_cruise_car for reservation c1095e41-1a77-433e-9b26-ea016413c59e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c1095e41-1a77-433e-9b26-ea016413c59e', '2025-08-14T07:12:36.476045+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c1095e41-1a77-433e-9b26-ea016413c59e');

-- ensure reservation for d7c84042-5bad-4045-924f-2ede2b78355d
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'd7c84042-5bad-4045-924f-2ede2b78355d', '6c10144f-651a-4ca0-8e43-7b067e9fcadf', '27eadf35-1b12-4fad-9276-58d5ee15c72a', 'car', 'confirmed', '2025-08-14T07:12:35.873147+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'd7c84042-5bad-4045-924f-2ede2b78355d');
UPDATE reservation SET re_quote_id = '27eadf35-1b12-4fad-9276-58d5ee15c72a', re_type = 'car'
WHERE re_id = 'd7c84042-5bad-4045-924f-2ede2b78355d' AND (re_quote_id IS DISTINCT FROM '27eadf35-1b12-4fad-9276-58d5ee15c72a' OR re_type <> 'car');
-- reservation_cruise_car for reservation d7c84042-5bad-4045-924f-2ede2b78355d
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'd7c84042-5bad-4045-924f-2ede2b78355d', '2025-08-14T07:12:35.873147+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'd7c84042-5bad-4045-924f-2ede2b78355d');

-- ensure reservation for 21fef400-4eed-476a-94d7-45157891e887
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '21fef400-4eed-476a-94d7-45157891e887', '2346a623-87da-4d35-a653-4477fa6e3d2c', '4fd0c57e-f67b-4e92-8e33-8e59411e2393', 'car', 'confirmed', '2025-08-14T07:12:35.27484+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '21fef400-4eed-476a-94d7-45157891e887');
UPDATE reservation SET re_quote_id = '4fd0c57e-f67b-4e92-8e33-8e59411e2393', re_type = 'car'
WHERE re_id = '21fef400-4eed-476a-94d7-45157891e887' AND (re_quote_id IS DISTINCT FROM '4fd0c57e-f67b-4e92-8e33-8e59411e2393' OR re_type <> 'car');
-- reservation_cruise_car for reservation 21fef400-4eed-476a-94d7-45157891e887
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '21fef400-4eed-476a-94d7-45157891e887', '2025-08-14T07:12:35.27484+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '21fef400-4eed-476a-94d7-45157891e887');

-- ensure reservation for 713703a7-16ae-4235-9365-3e65e8b2317e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '713703a7-16ae-4235-9365-3e65e8b2317e', '681317c7-1069-4303-9a35-27a3858b05f4', '6dbe750d-5c7f-4bf5-ab29-bfa84b80332e', 'car', 'confirmed', '2025-08-14T07:12:34.576221+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '713703a7-16ae-4235-9365-3e65e8b2317e');
UPDATE reservation SET re_quote_id = '6dbe750d-5c7f-4bf5-ab29-bfa84b80332e', re_type = 'car'
WHERE re_id = '713703a7-16ae-4235-9365-3e65e8b2317e' AND (re_quote_id IS DISTINCT FROM '6dbe750d-5c7f-4bf5-ab29-bfa84b80332e' OR re_type <> 'car');
-- reservation_cruise_car for reservation 713703a7-16ae-4235-9365-3e65e8b2317e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '713703a7-16ae-4235-9365-3e65e8b2317e', '2025-08-14T07:12:34.576221+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '713703a7-16ae-4235-9365-3e65e8b2317e');

-- ensure reservation for 0c5caea2-144b-4104-8b04-04ecf4e60b83
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0c5caea2-144b-4104-8b04-04ecf4e60b83', '3356c7f6-8d60-48bb-8859-3b3e11a5de11', '88f52618-7a97-4532-919c-3fd418dd8bf1', 'car', 'confirmed', '2025-08-14T07:12:33.991884+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0c5caea2-144b-4104-8b04-04ecf4e60b83');
UPDATE reservation SET re_quote_id = '88f52618-7a97-4532-919c-3fd418dd8bf1', re_type = 'car'
WHERE re_id = '0c5caea2-144b-4104-8b04-04ecf4e60b83' AND (re_quote_id IS DISTINCT FROM '88f52618-7a97-4532-919c-3fd418dd8bf1' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0c5caea2-144b-4104-8b04-04ecf4e60b83
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0c5caea2-144b-4104-8b04-04ecf4e60b83', '2025-08-14T07:12:33.991884+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0c5caea2-144b-4104-8b04-04ecf4e60b83');

-- ensure reservation for 2d9b96d4-91f6-4e7c-b67f-e917af129ffb
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2d9b96d4-91f6-4e7c-b67f-e917af129ffb', '3e19303b-d7e2-4ef8-ace7-a09867749a24', '24813bac-2f5a-4871-8e0e-70871a986439', 'car', 'confirmed', '2025-08-14T07:12:18.04845+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2d9b96d4-91f6-4e7c-b67f-e917af129ffb');
UPDATE reservation SET re_quote_id = '24813bac-2f5a-4871-8e0e-70871a986439', re_type = 'car'
WHERE re_id = '2d9b96d4-91f6-4e7c-b67f-e917af129ffb' AND (re_quote_id IS DISTINCT FROM '24813bac-2f5a-4871-8e0e-70871a986439' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2d9b96d4-91f6-4e7c-b67f-e917af129ffb
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2d9b96d4-91f6-4e7c-b67f-e917af129ffb', '2025-08-14T07:12:18.04845+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2d9b96d4-91f6-4e7c-b67f-e917af129ffb');

-- ensure reservation for 66ff3445-7710-4fb4-9155-3a60b3deba46
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '66ff3445-7710-4fb4-9155-3a60b3deba46', '60d8b6de-3658-4b06-bfde-8d41bcd6c562', 'e383f524-f2ce-41a9-92f1-79280b40453c', 'car', 'confirmed', '2025-08-14T07:12:13.717494+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '66ff3445-7710-4fb4-9155-3a60b3deba46');
UPDATE reservation SET re_quote_id = 'e383f524-f2ce-41a9-92f1-79280b40453c', re_type = 'car'
WHERE re_id = '66ff3445-7710-4fb4-9155-3a60b3deba46' AND (re_quote_id IS DISTINCT FROM 'e383f524-f2ce-41a9-92f1-79280b40453c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 66ff3445-7710-4fb4-9155-3a60b3deba46
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '66ff3445-7710-4fb4-9155-3a60b3deba46', '2025-08-14T07:12:13.717494+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '66ff3445-7710-4fb4-9155-3a60b3deba46');

-- ensure reservation for dfa73454-4e24-4698-b35e-d3d36fd98999
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'dfa73454-4e24-4698-b35e-d3d36fd98999', 'aba20d8f-6fe1-4e2d-9e76-940cc9fe89e2', '9334e9a1-02c1-4b45-b17a-08af35cfa417', 'car', 'confirmed', '2025-08-14T07:12:13.14113+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'dfa73454-4e24-4698-b35e-d3d36fd98999');
UPDATE reservation SET re_quote_id = '9334e9a1-02c1-4b45-b17a-08af35cfa417', re_type = 'car'
WHERE re_id = 'dfa73454-4e24-4698-b35e-d3d36fd98999' AND (re_quote_id IS DISTINCT FROM '9334e9a1-02c1-4b45-b17a-08af35cfa417' OR re_type <> 'car');
-- reservation_cruise_car for reservation dfa73454-4e24-4698-b35e-d3d36fd98999
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'dfa73454-4e24-4698-b35e-d3d36fd98999', '2025-08-14T07:12:13.14113+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'dfa73454-4e24-4698-b35e-d3d36fd98999');

-- ensure reservation for 95266b67-331f-4875-893d-bcf721acf7b4
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '95266b67-331f-4875-893d-bcf721acf7b4', 'd1852b65-20fc-437d-bf15-f74541a4b940', '4141a443-a604-4fbc-b568-d17e288a3305', 'car', 'confirmed', '2025-08-14T07:12:12.540332+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '95266b67-331f-4875-893d-bcf721acf7b4');
UPDATE reservation SET re_quote_id = '4141a443-a604-4fbc-b568-d17e288a3305', re_type = 'car'
WHERE re_id = '95266b67-331f-4875-893d-bcf721acf7b4' AND (re_quote_id IS DISTINCT FROM '4141a443-a604-4fbc-b568-d17e288a3305' OR re_type <> 'car');
-- reservation_cruise_car for reservation 95266b67-331f-4875-893d-bcf721acf7b4
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '95266b67-331f-4875-893d-bcf721acf7b4', '2025-08-14T07:12:12.540332+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '95266b67-331f-4875-893d-bcf721acf7b4');

-- ensure reservation for 0671305d-c80c-40da-a68e-e83aea41e92a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0671305d-c80c-40da-a68e-e83aea41e92a', 'aee855e5-590b-49b6-b5f1-dfacc9a6186c', 'ce50f722-adfc-405b-9b2f-7c94e946f034', 'car', 'confirmed', '2025-08-14T07:12:11.910759+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0671305d-c80c-40da-a68e-e83aea41e92a');
UPDATE reservation SET re_quote_id = 'ce50f722-adfc-405b-9b2f-7c94e946f034', re_type = 'car'
WHERE re_id = '0671305d-c80c-40da-a68e-e83aea41e92a' AND (re_quote_id IS DISTINCT FROM 'ce50f722-adfc-405b-9b2f-7c94e946f034' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0671305d-c80c-40da-a68e-e83aea41e92a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0671305d-c80c-40da-a68e-e83aea41e92a', '2025-08-14T07:12:11.910759+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0671305d-c80c-40da-a68e-e83aea41e92a');

-- ensure reservation for e9fc2cad-445d-4361-8ba3-844c30188448
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e9fc2cad-445d-4361-8ba3-844c30188448', 'd6000b34-7743-475b-8712-8a64eadefdea', '20e3e654-97ac-48f3-a851-02ad93aedb97', 'car', 'confirmed', '2025-08-14T07:12:11.290472+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e9fc2cad-445d-4361-8ba3-844c30188448');
UPDATE reservation SET re_quote_id = '20e3e654-97ac-48f3-a851-02ad93aedb97', re_type = 'car'
WHERE re_id = 'e9fc2cad-445d-4361-8ba3-844c30188448' AND (re_quote_id IS DISTINCT FROM '20e3e654-97ac-48f3-a851-02ad93aedb97' OR re_type <> 'car');
-- reservation_cruise_car for reservation e9fc2cad-445d-4361-8ba3-844c30188448
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e9fc2cad-445d-4361-8ba3-844c30188448', '2025-08-14T07:12:11.290472+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e9fc2cad-445d-4361-8ba3-844c30188448');

-- ensure reservation for 2710866b-8660-4227-be9b-dac3b3362790
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2710866b-8660-4227-be9b-dac3b3362790', 'a64166ee-df9d-4e9e-8b67-6d5d6c0ddba1', '7f421b55-2b70-42cc-899d-bd5a038bd97c', 'car', 'confirmed', '2025-08-14T07:12:10.640621+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2710866b-8660-4227-be9b-dac3b3362790');
UPDATE reservation SET re_quote_id = '7f421b55-2b70-42cc-899d-bd5a038bd97c', re_type = 'car'
WHERE re_id = '2710866b-8660-4227-be9b-dac3b3362790' AND (re_quote_id IS DISTINCT FROM '7f421b55-2b70-42cc-899d-bd5a038bd97c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2710866b-8660-4227-be9b-dac3b3362790
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2710866b-8660-4227-be9b-dac3b3362790', '2025-08-14T07:12:10.640621+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2710866b-8660-4227-be9b-dac3b3362790');

-- ensure reservation for d99fa55d-0762-49d0-b814-8dfff8a5cf5a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'd99fa55d-0762-49d0-b814-8dfff8a5cf5a', '1dc57b51-5f4f-426f-8c38-32c30c1b8666', '96fadaa4-fcec-4056-ae1d-19aa7a656b88', 'car', 'confirmed', '2025-08-14T07:12:10.015045+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'd99fa55d-0762-49d0-b814-8dfff8a5cf5a');
UPDATE reservation SET re_quote_id = '96fadaa4-fcec-4056-ae1d-19aa7a656b88', re_type = 'car'
WHERE re_id = 'd99fa55d-0762-49d0-b814-8dfff8a5cf5a' AND (re_quote_id IS DISTINCT FROM '96fadaa4-fcec-4056-ae1d-19aa7a656b88' OR re_type <> 'car');
-- reservation_cruise_car for reservation d99fa55d-0762-49d0-b814-8dfff8a5cf5a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'd99fa55d-0762-49d0-b814-8dfff8a5cf5a', '2025-08-14T07:12:10.015045+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'd99fa55d-0762-49d0-b814-8dfff8a5cf5a');

-- ensure reservation for b18dc74f-ff35-46b6-8315-b922883017ae
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'b18dc74f-ff35-46b6-8315-b922883017ae', 'aba20d8f-6fe1-4e2d-9e76-940cc9fe89e2', '9334e9a1-02c1-4b45-b17a-08af35cfa417', 'car', 'confirmed', '2025-08-14T07:12:09.380374+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'b18dc74f-ff35-46b6-8315-b922883017ae');
UPDATE reservation SET re_quote_id = '9334e9a1-02c1-4b45-b17a-08af35cfa417', re_type = 'car'
WHERE re_id = 'b18dc74f-ff35-46b6-8315-b922883017ae' AND (re_quote_id IS DISTINCT FROM '9334e9a1-02c1-4b45-b17a-08af35cfa417' OR re_type <> 'car');
-- reservation_cruise_car for reservation b18dc74f-ff35-46b6-8315-b922883017ae
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'b18dc74f-ff35-46b6-8315-b922883017ae', '2025-08-14T07:12:09.380374+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'b18dc74f-ff35-46b6-8315-b922883017ae');

-- ensure reservation for 8e49c778-1c5e-4870-aa44-9d6a95f8bef5
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '8e49c778-1c5e-4870-aa44-9d6a95f8bef5', 'd1852b65-20fc-437d-bf15-f74541a4b940', '4141a443-a604-4fbc-b568-d17e288a3305', 'car', 'confirmed', '2025-08-14T07:12:08.734758+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '8e49c778-1c5e-4870-aa44-9d6a95f8bef5');
UPDATE reservation SET re_quote_id = '4141a443-a604-4fbc-b568-d17e288a3305', re_type = 'car'
WHERE re_id = '8e49c778-1c5e-4870-aa44-9d6a95f8bef5' AND (re_quote_id IS DISTINCT FROM '4141a443-a604-4fbc-b568-d17e288a3305' OR re_type <> 'car');
-- reservation_cruise_car for reservation 8e49c778-1c5e-4870-aa44-9d6a95f8bef5
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '8e49c778-1c5e-4870-aa44-9d6a95f8bef5', '2025-08-14T07:12:08.734758+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '8e49c778-1c5e-4870-aa44-9d6a95f8bef5');

-- ensure reservation for 18c19306-b687-4b13-b882-6c04dbb206d8
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '18c19306-b687-4b13-b882-6c04dbb206d8', '58a99a31-e92a-4396-8279-383e7cc32a5e', '175eb48b-34f6-4be7-bd3f-c6eb125750eb', 'car', 'confirmed', '2025-08-14T07:12:08.132485+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '18c19306-b687-4b13-b882-6c04dbb206d8');
UPDATE reservation SET re_quote_id = '175eb48b-34f6-4be7-bd3f-c6eb125750eb', re_type = 'car'
WHERE re_id = '18c19306-b687-4b13-b882-6c04dbb206d8' AND (re_quote_id IS DISTINCT FROM '175eb48b-34f6-4be7-bd3f-c6eb125750eb' OR re_type <> 'car');
-- reservation_cruise_car for reservation 18c19306-b687-4b13-b882-6c04dbb206d8
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '18c19306-b687-4b13-b882-6c04dbb206d8', '2025-08-14T07:12:08.132485+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '18c19306-b687-4b13-b882-6c04dbb206d8');

-- ensure reservation for 948b5436-b537-413a-81db-235a8ccad012
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '948b5436-b537-413a-81db-235a8ccad012', '564a7018-90e4-4574-9a7d-d7b96d43b7e3', 'b6ae1aa9-5354-4124-ae3b-e7e2b4b31dc5', 'car', 'confirmed', '2025-08-14T07:12:07.544194+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '948b5436-b537-413a-81db-235a8ccad012');
UPDATE reservation SET re_quote_id = 'b6ae1aa9-5354-4124-ae3b-e7e2b4b31dc5', re_type = 'car'
WHERE re_id = '948b5436-b537-413a-81db-235a8ccad012' AND (re_quote_id IS DISTINCT FROM 'b6ae1aa9-5354-4124-ae3b-e7e2b4b31dc5' OR re_type <> 'car');
-- reservation_cruise_car for reservation 948b5436-b537-413a-81db-235a8ccad012
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '948b5436-b537-413a-81db-235a8ccad012', '2025-08-14T07:12:07.544194+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '948b5436-b537-413a-81db-235a8ccad012');

-- ensure reservation for 3187b5b2-ab90-4de5-b466-a8eb47137e3f
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '3187b5b2-ab90-4de5-b466-a8eb47137e3f', '9ade5adf-12a3-479e-91ce-9a8d13279cf7', '379e8755-b806-41db-b08d-2ca2df898994', 'car', 'confirmed', '2025-08-14T07:12:06.957213+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '3187b5b2-ab90-4de5-b466-a8eb47137e3f');
UPDATE reservation SET re_quote_id = '379e8755-b806-41db-b08d-2ca2df898994', re_type = 'car'
WHERE re_id = '3187b5b2-ab90-4de5-b466-a8eb47137e3f' AND (re_quote_id IS DISTINCT FROM '379e8755-b806-41db-b08d-2ca2df898994' OR re_type <> 'car');
-- reservation_cruise_car for reservation 3187b5b2-ab90-4de5-b466-a8eb47137e3f
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '3187b5b2-ab90-4de5-b466-a8eb47137e3f', '2025-08-14T07:12:06.957213+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '3187b5b2-ab90-4de5-b466-a8eb47137e3f');

-- ensure reservation for c6153acb-9cf5-4d46-8578-295c8b3ae40a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c6153acb-9cf5-4d46-8578-295c8b3ae40a', 'ca025d7d-82e6-4f9d-b4dc-bd41cdfbf7e6', '3bf1a7e6-61a7-4795-b29d-a0c9267800ad', 'car', 'confirmed', '2025-08-14T07:12:06.389589+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c6153acb-9cf5-4d46-8578-295c8b3ae40a');
UPDATE reservation SET re_quote_id = '3bf1a7e6-61a7-4795-b29d-a0c9267800ad', re_type = 'car'
WHERE re_id = 'c6153acb-9cf5-4d46-8578-295c8b3ae40a' AND (re_quote_id IS DISTINCT FROM '3bf1a7e6-61a7-4795-b29d-a0c9267800ad' OR re_type <> 'car');
-- reservation_cruise_car for reservation c6153acb-9cf5-4d46-8578-295c8b3ae40a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c6153acb-9cf5-4d46-8578-295c8b3ae40a', '2025-08-14T07:12:06.389589+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c6153acb-9cf5-4d46-8578-295c8b3ae40a');

-- ensure reservation for 1a1aa041-e3d7-4000-b2cb-aedb95bbeda8
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1a1aa041-e3d7-4000-b2cb-aedb95bbeda8', 'd6000b34-7743-475b-8712-8a64eadefdea', '20e3e654-97ac-48f3-a851-02ad93aedb97', 'car', 'confirmed', '2025-08-14T07:12:05.780404+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1a1aa041-e3d7-4000-b2cb-aedb95bbeda8');
UPDATE reservation SET re_quote_id = '20e3e654-97ac-48f3-a851-02ad93aedb97', re_type = 'car'
WHERE re_id = '1a1aa041-e3d7-4000-b2cb-aedb95bbeda8' AND (re_quote_id IS DISTINCT FROM '20e3e654-97ac-48f3-a851-02ad93aedb97' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1a1aa041-e3d7-4000-b2cb-aedb95bbeda8
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1a1aa041-e3d7-4000-b2cb-aedb95bbeda8', '2025-08-14T07:12:05.780404+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1a1aa041-e3d7-4000-b2cb-aedb95bbeda8');

-- ensure reservation for cda9e02f-538d-4327-87ea-175c31972972
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'cda9e02f-538d-4327-87ea-175c31972972', '4ac63704-50c5-45e6-83b1-4c6a5139fa05', 'f5c41a04-f688-4ed9-a206-1eedffc9f0c8', 'car', 'confirmed', '2025-08-14T07:12:05.160948+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'cda9e02f-538d-4327-87ea-175c31972972');
UPDATE reservation SET re_quote_id = 'f5c41a04-f688-4ed9-a206-1eedffc9f0c8', re_type = 'car'
WHERE re_id = 'cda9e02f-538d-4327-87ea-175c31972972' AND (re_quote_id IS DISTINCT FROM 'f5c41a04-f688-4ed9-a206-1eedffc9f0c8' OR re_type <> 'car');
-- reservation_cruise_car for reservation cda9e02f-538d-4327-87ea-175c31972972
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'cda9e02f-538d-4327-87ea-175c31972972', '2025-08-14T07:12:05.160948+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'cda9e02f-538d-4327-87ea-175c31972972');

-- ensure reservation for 26dce591-f01e-4c0c-8b40-373fceb55a83
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '26dce591-f01e-4c0c-8b40-373fceb55a83', '4f91c643-0a15-47dc-a232-8f23d4cd25a2', '1c11a129-702b-4cda-bb9a-586c2d3b0078', 'car', 'confirmed', '2025-08-14T07:12:04.504288+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '26dce591-f01e-4c0c-8b40-373fceb55a83');
UPDATE reservation SET re_quote_id = '1c11a129-702b-4cda-bb9a-586c2d3b0078', re_type = 'car'
WHERE re_id = '26dce591-f01e-4c0c-8b40-373fceb55a83' AND (re_quote_id IS DISTINCT FROM '1c11a129-702b-4cda-bb9a-586c2d3b0078' OR re_type <> 'car');
-- reservation_cruise_car for reservation 26dce591-f01e-4c0c-8b40-373fceb55a83
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '26dce591-f01e-4c0c-8b40-373fceb55a83', '2025-08-14T07:12:04.504288+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '26dce591-f01e-4c0c-8b40-373fceb55a83');

-- ensure reservation for eef0c587-6fdd-40ee-8e2f-b95bfb14ca93
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'eef0c587-6fdd-40ee-8e2f-b95bfb14ca93', '1a087dd7-75aa-4de4-a471-62287b38d4c1', 'cb8f3b7d-a134-4f4f-89db-26ab80930b25', 'car', 'confirmed', '2025-08-14T07:12:03.878715+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'eef0c587-6fdd-40ee-8e2f-b95bfb14ca93');
UPDATE reservation SET re_quote_id = 'cb8f3b7d-a134-4f4f-89db-26ab80930b25', re_type = 'car'
WHERE re_id = 'eef0c587-6fdd-40ee-8e2f-b95bfb14ca93' AND (re_quote_id IS DISTINCT FROM 'cb8f3b7d-a134-4f4f-89db-26ab80930b25' OR re_type <> 'car');
-- reservation_cruise_car for reservation eef0c587-6fdd-40ee-8e2f-b95bfb14ca93
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'eef0c587-6fdd-40ee-8e2f-b95bfb14ca93', '2025-08-14T07:12:03.878715+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'eef0c587-6fdd-40ee-8e2f-b95bfb14ca93');

-- ensure reservation for df568662-d652-45c7-acdc-7a15bc372640
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'df568662-d652-45c7-acdc-7a15bc372640', '034b7b1c-df82-493f-884d-5bbc45db3303', '0fdbfe9c-1420-46d0-9781-11f92713589c', 'car', 'confirmed', '2025-08-14T07:12:03.29893+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'df568662-d652-45c7-acdc-7a15bc372640');
UPDATE reservation SET re_quote_id = '0fdbfe9c-1420-46d0-9781-11f92713589c', re_type = 'car'
WHERE re_id = 'df568662-d652-45c7-acdc-7a15bc372640' AND (re_quote_id IS DISTINCT FROM '0fdbfe9c-1420-46d0-9781-11f92713589c' OR re_type <> 'car');
-- reservation_cruise_car for reservation df568662-d652-45c7-acdc-7a15bc372640
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'df568662-d652-45c7-acdc-7a15bc372640', '2025-08-14T07:12:03.29893+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'df568662-d652-45c7-acdc-7a15bc372640');

-- ensure reservation for 9887fb92-c8d1-4909-8f24-336b89aff41e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '9887fb92-c8d1-4909-8f24-336b89aff41e', 'da02cb48-c08b-475d-8248-e376179a02ba', '82ac0543-461f-4178-8800-8fc716892577', 'car', 'confirmed', '2025-08-14T07:12:02.6811+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '9887fb92-c8d1-4909-8f24-336b89aff41e');
UPDATE reservation SET re_quote_id = '82ac0543-461f-4178-8800-8fc716892577', re_type = 'car'
WHERE re_id = '9887fb92-c8d1-4909-8f24-336b89aff41e' AND (re_quote_id IS DISTINCT FROM '82ac0543-461f-4178-8800-8fc716892577' OR re_type <> 'car');
-- reservation_cruise_car for reservation 9887fb92-c8d1-4909-8f24-336b89aff41e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '9887fb92-c8d1-4909-8f24-336b89aff41e', '2025-08-14T07:12:02.6811+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '9887fb92-c8d1-4909-8f24-336b89aff41e');

-- ensure reservation for 1a06c45e-68b1-4c4c-94e6-e608c0657ec3
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1a06c45e-68b1-4c4c-94e6-e608c0657ec3', '15a22ad7-8086-4fec-b2c2-ec3d4805afb0', '94d58af2-6597-4277-90f4-e02630d29868', 'car', 'confirmed', '2025-08-14T07:11:57.528725+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1a06c45e-68b1-4c4c-94e6-e608c0657ec3');
UPDATE reservation SET re_quote_id = '94d58af2-6597-4277-90f4-e02630d29868', re_type = 'car'
WHERE re_id = '1a06c45e-68b1-4c4c-94e6-e608c0657ec3' AND (re_quote_id IS DISTINCT FROM '94d58af2-6597-4277-90f4-e02630d29868' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1a06c45e-68b1-4c4c-94e6-e608c0657ec3
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1a06c45e-68b1-4c4c-94e6-e608c0657ec3', '2025-08-14T07:11:57.528725+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1a06c45e-68b1-4c4c-94e6-e608c0657ec3');

-- ensure reservation for c35c1988-16f8-4c95-ac1a-f54b3dae59c6
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'c35c1988-16f8-4c95-ac1a-f54b3dae59c6', 'ac4feed5-29b2-4ce8-88f3-36aab292f20f', 'b37c3043-42ea-474f-b363-4cee63cc157e', 'car', 'confirmed', '2025-08-14T07:11:43.160462+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'c35c1988-16f8-4c95-ac1a-f54b3dae59c6');
UPDATE reservation SET re_quote_id = 'b37c3043-42ea-474f-b363-4cee63cc157e', re_type = 'car'
WHERE re_id = 'c35c1988-16f8-4c95-ac1a-f54b3dae59c6' AND (re_quote_id IS DISTINCT FROM 'b37c3043-42ea-474f-b363-4cee63cc157e' OR re_type <> 'car');
-- reservation_cruise_car for reservation c35c1988-16f8-4c95-ac1a-f54b3dae59c6
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'c35c1988-16f8-4c95-ac1a-f54b3dae59c6', '2025-08-14T07:11:43.160462+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'c35c1988-16f8-4c95-ac1a-f54b3dae59c6');

-- ensure reservation for 0a5cf8b8-9ff2-4289-9892-ba5420d9b743
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0a5cf8b8-9ff2-4289-9892-ba5420d9b743', 'b132ad81-ac85-4dcc-834a-50b76fed24e6', '22c495a7-dfd8-429f-9c88-d3202e7d43d6', 'car', 'confirmed', '2025-08-14T07:11:42.555601+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0a5cf8b8-9ff2-4289-9892-ba5420d9b743');
UPDATE reservation SET re_quote_id = '22c495a7-dfd8-429f-9c88-d3202e7d43d6', re_type = 'car'
WHERE re_id = '0a5cf8b8-9ff2-4289-9892-ba5420d9b743' AND (re_quote_id IS DISTINCT FROM '22c495a7-dfd8-429f-9c88-d3202e7d43d6' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0a5cf8b8-9ff2-4289-9892-ba5420d9b743
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0a5cf8b8-9ff2-4289-9892-ba5420d9b743', '2025-08-14T07:11:42.555601+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0a5cf8b8-9ff2-4289-9892-ba5420d9b743');

-- ensure reservation for f3060535-700b-44dc-9e09-6e27381c241e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'f3060535-700b-44dc-9e09-6e27381c241e', 'f9d48a7d-607f-4909-9e15-3947706e8605', '2592cc49-1101-4a93-ae5c-61a17b1143f0', 'car', 'confirmed', '2025-08-14T07:11:41.98456+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'f3060535-700b-44dc-9e09-6e27381c241e');
UPDATE reservation SET re_quote_id = '2592cc49-1101-4a93-ae5c-61a17b1143f0', re_type = 'car'
WHERE re_id = 'f3060535-700b-44dc-9e09-6e27381c241e' AND (re_quote_id IS DISTINCT FROM '2592cc49-1101-4a93-ae5c-61a17b1143f0' OR re_type <> 'car');
-- reservation_cruise_car for reservation f3060535-700b-44dc-9e09-6e27381c241e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'f3060535-700b-44dc-9e09-6e27381c241e', '2025-08-14T07:11:41.98456+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'f3060535-700b-44dc-9e09-6e27381c241e');

-- ensure reservation for 518a94d1-686f-489a-8783-b643e0eaa95d
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '518a94d1-686f-489a-8783-b643e0eaa95d', '8e508dac-d016-4db6-b494-7d3dccf009d6', '38423cee-2dc5-49ac-ad91-f7149a9d4cbf', 'car', 'confirmed', '2025-08-14T07:11:41.399325+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '518a94d1-686f-489a-8783-b643e0eaa95d');
UPDATE reservation SET re_quote_id = '38423cee-2dc5-49ac-ad91-f7149a9d4cbf', re_type = 'car'
WHERE re_id = '518a94d1-686f-489a-8783-b643e0eaa95d' AND (re_quote_id IS DISTINCT FROM '38423cee-2dc5-49ac-ad91-f7149a9d4cbf' OR re_type <> 'car');
-- reservation_cruise_car for reservation 518a94d1-686f-489a-8783-b643e0eaa95d
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '518a94d1-686f-489a-8783-b643e0eaa95d', '2025-08-14T07:11:41.399325+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '518a94d1-686f-489a-8783-b643e0eaa95d');

-- ensure reservation for e079dd99-9562-4cff-8cda-02e3728ba23b
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e079dd99-9562-4cff-8cda-02e3728ba23b', 'b7350844-3f5f-478b-aa6c-1a1d5ba2181c', 'ffa4cd31-6258-4fee-afb6-67608c23d41c', 'car', 'confirmed', '2025-08-14T07:11:40.789983+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e079dd99-9562-4cff-8cda-02e3728ba23b');
UPDATE reservation SET re_quote_id = 'ffa4cd31-6258-4fee-afb6-67608c23d41c', re_type = 'car'
WHERE re_id = 'e079dd99-9562-4cff-8cda-02e3728ba23b' AND (re_quote_id IS DISTINCT FROM 'ffa4cd31-6258-4fee-afb6-67608c23d41c' OR re_type <> 'car');
-- reservation_cruise_car for reservation e079dd99-9562-4cff-8cda-02e3728ba23b
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e079dd99-9562-4cff-8cda-02e3728ba23b', '2025-08-14T07:11:40.789983+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e079dd99-9562-4cff-8cda-02e3728ba23b');

-- ensure reservation for 4a18a386-f17c-4f10-a98f-8fe70f6e0b84
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '4a18a386-f17c-4f10-a98f-8fe70f6e0b84', '8363e192-6b21-4237-a23f-146ae71758ad', '1ae62a4d-1770-441a-8922-42d29a084fe2', 'car', 'confirmed', '2025-08-14T07:11:40.173279+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '4a18a386-f17c-4f10-a98f-8fe70f6e0b84');
UPDATE reservation SET re_quote_id = '1ae62a4d-1770-441a-8922-42d29a084fe2', re_type = 'car'
WHERE re_id = '4a18a386-f17c-4f10-a98f-8fe70f6e0b84' AND (re_quote_id IS DISTINCT FROM '1ae62a4d-1770-441a-8922-42d29a084fe2' OR re_type <> 'car');
-- reservation_cruise_car for reservation 4a18a386-f17c-4f10-a98f-8fe70f6e0b84
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '4a18a386-f17c-4f10-a98f-8fe70f6e0b84', '2025-08-14T07:11:40.173279+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '4a18a386-f17c-4f10-a98f-8fe70f6e0b84');

-- ensure reservation for e7671ab8-4701-4f15-8ce2-f5c65d9e25da
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e7671ab8-4701-4f15-8ce2-f5c65d9e25da', '07f4bf17-b8d6-476c-b968-b1eb5b0dc9b7', 'b480f570-d7da-4fa1-9fb2-6cb5b5948265', 'car', 'confirmed', '2025-08-14T07:11:39.605042+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e7671ab8-4701-4f15-8ce2-f5c65d9e25da');
UPDATE reservation SET re_quote_id = 'b480f570-d7da-4fa1-9fb2-6cb5b5948265', re_type = 'car'
WHERE re_id = 'e7671ab8-4701-4f15-8ce2-f5c65d9e25da' AND (re_quote_id IS DISTINCT FROM 'b480f570-d7da-4fa1-9fb2-6cb5b5948265' OR re_type <> 'car');
-- reservation_cruise_car for reservation e7671ab8-4701-4f15-8ce2-f5c65d9e25da
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e7671ab8-4701-4f15-8ce2-f5c65d9e25da', '2025-08-14T07:11:39.605042+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e7671ab8-4701-4f15-8ce2-f5c65d9e25da');

-- ensure reservation for f632dbf7-47cc-4eab-90f5-586a904022e4
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'f632dbf7-47cc-4eab-90f5-586a904022e4', '344caf54-76e4-4f77-8200-197037242eae', '0abbd14e-d452-49ad-a1da-5b59751e3d45', 'car', 'confirmed', '2025-08-14T07:11:39.005306+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'f632dbf7-47cc-4eab-90f5-586a904022e4');
UPDATE reservation SET re_quote_id = '0abbd14e-d452-49ad-a1da-5b59751e3d45', re_type = 'car'
WHERE re_id = 'f632dbf7-47cc-4eab-90f5-586a904022e4' AND (re_quote_id IS DISTINCT FROM '0abbd14e-d452-49ad-a1da-5b59751e3d45' OR re_type <> 'car');
-- reservation_cruise_car for reservation f632dbf7-47cc-4eab-90f5-586a904022e4
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'f632dbf7-47cc-4eab-90f5-586a904022e4', '2025-08-14T07:11:39.005306+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'f632dbf7-47cc-4eab-90f5-586a904022e4');

-- ensure reservation for 1ae9d053-241b-4115-aa02-d214e525fee3
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1ae9d053-241b-4115-aa02-d214e525fee3', '8e508dac-d016-4db6-b494-7d3dccf009d6', '38423cee-2dc5-49ac-ad91-f7149a9d4cbf', 'car', 'confirmed', '2025-08-14T07:11:38.370759+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1ae9d053-241b-4115-aa02-d214e525fee3');
UPDATE reservation SET re_quote_id = '38423cee-2dc5-49ac-ad91-f7149a9d4cbf', re_type = 'car'
WHERE re_id = '1ae9d053-241b-4115-aa02-d214e525fee3' AND (re_quote_id IS DISTINCT FROM '38423cee-2dc5-49ac-ad91-f7149a9d4cbf' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1ae9d053-241b-4115-aa02-d214e525fee3
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1ae9d053-241b-4115-aa02-d214e525fee3', '2025-08-14T07:11:38.370759+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1ae9d053-241b-4115-aa02-d214e525fee3');

-- ensure reservation for 8d81ec11-1fa0-4f31-a588-5f8007a27687
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '8d81ec11-1fa0-4f31-a588-5f8007a27687', 'a36952a4-d150-42ed-8309-7b511860b60f', '7ad8f122-7e36-40af-9e37-10a014c6ea76', 'car', 'confirmed', '2025-08-14T07:11:37.717978+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '8d81ec11-1fa0-4f31-a588-5f8007a27687');
UPDATE reservation SET re_quote_id = '7ad8f122-7e36-40af-9e37-10a014c6ea76', re_type = 'car'
WHERE re_id = '8d81ec11-1fa0-4f31-a588-5f8007a27687' AND (re_quote_id IS DISTINCT FROM '7ad8f122-7e36-40af-9e37-10a014c6ea76' OR re_type <> 'car');
-- reservation_cruise_car for reservation 8d81ec11-1fa0-4f31-a588-5f8007a27687
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '8d81ec11-1fa0-4f31-a588-5f8007a27687', '2025-08-14T07:11:37.717978+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '8d81ec11-1fa0-4f31-a588-5f8007a27687');

-- ensure reservation for 1b461ac5-e5cd-4fd4-a896-7e7a494c2832
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1b461ac5-e5cd-4fd4-a896-7e7a494c2832', '51006edb-f887-4f7b-95a5-9658fa5a571e', '677c317b-7638-47d0-accf-16bf79d0f7ae', 'car', 'confirmed', '2025-08-14T07:11:27.506459+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1b461ac5-e5cd-4fd4-a896-7e7a494c2832');
UPDATE reservation SET re_quote_id = '677c317b-7638-47d0-accf-16bf79d0f7ae', re_type = 'car'
WHERE re_id = '1b461ac5-e5cd-4fd4-a896-7e7a494c2832' AND (re_quote_id IS DISTINCT FROM '677c317b-7638-47d0-accf-16bf79d0f7ae' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1b461ac5-e5cd-4fd4-a896-7e7a494c2832
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1b461ac5-e5cd-4fd4-a896-7e7a494c2832', '2025-08-14T07:11:27.506459+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1b461ac5-e5cd-4fd4-a896-7e7a494c2832');

-- ensure reservation for 6f2bbbef-2633-465a-869b-752b7fde99ff
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '6f2bbbef-2633-465a-869b-752b7fde99ff', '51006edb-f887-4f7b-95a5-9658fa5a571e', '677c317b-7638-47d0-accf-16bf79d0f7ae', 'car', 'confirmed', '2025-08-14T07:11:26.916331+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '6f2bbbef-2633-465a-869b-752b7fde99ff');
UPDATE reservation SET re_quote_id = '677c317b-7638-47d0-accf-16bf79d0f7ae', re_type = 'car'
WHERE re_id = '6f2bbbef-2633-465a-869b-752b7fde99ff' AND (re_quote_id IS DISTINCT FROM '677c317b-7638-47d0-accf-16bf79d0f7ae' OR re_type <> 'car');
-- reservation_cruise_car for reservation 6f2bbbef-2633-465a-869b-752b7fde99ff
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '6f2bbbef-2633-465a-869b-752b7fde99ff', '2025-08-14T07:11:26.916331+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '6f2bbbef-2633-465a-869b-752b7fde99ff');

-- ensure reservation for 25d17ad7-733b-4e32-8c31-180b175b0a65
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '25d17ad7-733b-4e32-8c31-180b175b0a65', '0e6e18f3-953d-4b3a-8dd2-4fe23c024fb3', 'a75cc0ca-2b2f-4d61-905c-99dc4f02bd3c', 'car', 'confirmed', '2025-08-14T07:11:25.168758+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '25d17ad7-733b-4e32-8c31-180b175b0a65');
UPDATE reservation SET re_quote_id = 'a75cc0ca-2b2f-4d61-905c-99dc4f02bd3c', re_type = 'car'
WHERE re_id = '25d17ad7-733b-4e32-8c31-180b175b0a65' AND (re_quote_id IS DISTINCT FROM 'a75cc0ca-2b2f-4d61-905c-99dc4f02bd3c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 25d17ad7-733b-4e32-8c31-180b175b0a65
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '25d17ad7-733b-4e32-8c31-180b175b0a65', '2025-08-14T07:11:25.168758+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '25d17ad7-733b-4e32-8c31-180b175b0a65');

-- ensure reservation for 5e1ed0b0-36cb-49d3-a66f-817604b3c902
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '5e1ed0b0-36cb-49d3-a66f-817604b3c902', '0e6e18f3-953d-4b3a-8dd2-4fe23c024fb3', 'a75cc0ca-2b2f-4d61-905c-99dc4f02bd3c', 'car', 'confirmed', '2025-08-14T07:11:24.552434+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '5e1ed0b0-36cb-49d3-a66f-817604b3c902');
UPDATE reservation SET re_quote_id = 'a75cc0ca-2b2f-4d61-905c-99dc4f02bd3c', re_type = 'car'
WHERE re_id = '5e1ed0b0-36cb-49d3-a66f-817604b3c902' AND (re_quote_id IS DISTINCT FROM 'a75cc0ca-2b2f-4d61-905c-99dc4f02bd3c' OR re_type <> 'car');
-- reservation_cruise_car for reservation 5e1ed0b0-36cb-49d3-a66f-817604b3c902
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '5e1ed0b0-36cb-49d3-a66f-817604b3c902', '2025-08-14T07:11:24.552434+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '5e1ed0b0-36cb-49d3-a66f-817604b3c902');

-- ensure reservation for e131dc54-f077-4cc8-9cc0-912769da6a3a
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'e131dc54-f077-4cc8-9cc0-912769da6a3a', 'f0cdf939-4878-46ec-bce6-8eb51e24c8ae', '9166a716-8ff5-4668-a991-f006b4b5d3a7', 'car', 'confirmed', '2025-08-14T07:11:21.551221+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'e131dc54-f077-4cc8-9cc0-912769da6a3a');
UPDATE reservation SET re_quote_id = '9166a716-8ff5-4668-a991-f006b4b5d3a7', re_type = 'car'
WHERE re_id = 'e131dc54-f077-4cc8-9cc0-912769da6a3a' AND (re_quote_id IS DISTINCT FROM '9166a716-8ff5-4668-a991-f006b4b5d3a7' OR re_type <> 'car');
-- reservation_cruise_car for reservation e131dc54-f077-4cc8-9cc0-912769da6a3a
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'e131dc54-f077-4cc8-9cc0-912769da6a3a', '2025-08-14T07:11:21.551221+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'e131dc54-f077-4cc8-9cc0-912769da6a3a');

-- ensure reservation for 2509cd3e-a671-44ca-bffe-a554922a64c6
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '2509cd3e-a671-44ca-bffe-a554922a64c6', '8a74bd0d-125f-41e1-8cb3-0442928f0fbf', 'ce7ec3db-ddc7-479b-ac6a-c9ed51fd101b', 'car', 'confirmed', '2025-08-14T07:11:19.819127+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '2509cd3e-a671-44ca-bffe-a554922a64c6');
UPDATE reservation SET re_quote_id = 'ce7ec3db-ddc7-479b-ac6a-c9ed51fd101b', re_type = 'car'
WHERE re_id = '2509cd3e-a671-44ca-bffe-a554922a64c6' AND (re_quote_id IS DISTINCT FROM 'ce7ec3db-ddc7-479b-ac6a-c9ed51fd101b' OR re_type <> 'car');
-- reservation_cruise_car for reservation 2509cd3e-a671-44ca-bffe-a554922a64c6
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '2509cd3e-a671-44ca-bffe-a554922a64c6', '2025-08-14T07:11:19.819127+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '2509cd3e-a671-44ca-bffe-a554922a64c6');

-- ensure reservation for 293f3beb-8958-4c21-9346-5a7475c59c16
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '293f3beb-8958-4c21-9346-5a7475c59c16', '2aec55fb-091d-428e-baf0-c722c72d870b', '01878ce4-683b-4aab-99fe-fcc9dd87b3ae', 'car', 'confirmed', '2025-08-14T07:11:18.819344+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '293f3beb-8958-4c21-9346-5a7475c59c16');
UPDATE reservation SET re_quote_id = '01878ce4-683b-4aab-99fe-fcc9dd87b3ae', re_type = 'car'
WHERE re_id = '293f3beb-8958-4c21-9346-5a7475c59c16' AND (re_quote_id IS DISTINCT FROM '01878ce4-683b-4aab-99fe-fcc9dd87b3ae' OR re_type <> 'car');
-- reservation_cruise_car for reservation 293f3beb-8958-4c21-9346-5a7475c59c16
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '293f3beb-8958-4c21-9346-5a7475c59c16', '2025-08-14T07:11:18.819344+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '293f3beb-8958-4c21-9346-5a7475c59c16');

-- ensure reservation for 020ef2d2-2f0d-407d-aa39-469c50646e81
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '020ef2d2-2f0d-407d-aa39-469c50646e81', 'a104d47f-77c0-41ac-8f07-1084ce470547', 'ef3a057e-e668-4672-bcb4-ae997fb0a25e', 'car', 'confirmed', '2025-08-14T07:11:15.602908+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '020ef2d2-2f0d-407d-aa39-469c50646e81');
UPDATE reservation SET re_quote_id = 'ef3a057e-e668-4672-bcb4-ae997fb0a25e', re_type = 'car'
WHERE re_id = '020ef2d2-2f0d-407d-aa39-469c50646e81' AND (re_quote_id IS DISTINCT FROM 'ef3a057e-e668-4672-bcb4-ae997fb0a25e' OR re_type <> 'car');
-- reservation_cruise_car for reservation 020ef2d2-2f0d-407d-aa39-469c50646e81
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '020ef2d2-2f0d-407d-aa39-469c50646e81', '2025-08-14T07:11:15.602908+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '020ef2d2-2f0d-407d-aa39-469c50646e81');

-- ensure reservation for a74c9644-d569-493a-a0ac-3f59d864ba9f
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT 'a74c9644-d569-493a-a0ac-3f59d864ba9f', 'f7562e9d-917e-4fd9-8535-968292a3623e', '66959892-324d-40cd-9c41-742fca61295e', 'car', 'confirmed', '2025-08-14T07:11:13.169672+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = 'a74c9644-d569-493a-a0ac-3f59d864ba9f');
UPDATE reservation SET re_quote_id = '66959892-324d-40cd-9c41-742fca61295e', re_type = 'car'
WHERE re_id = 'a74c9644-d569-493a-a0ac-3f59d864ba9f' AND (re_quote_id IS DISTINCT FROM '66959892-324d-40cd-9c41-742fca61295e' OR re_type <> 'car');
-- reservation_cruise_car for reservation a74c9644-d569-493a-a0ac-3f59d864ba9f
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT 'a74c9644-d569-493a-a0ac-3f59d864ba9f', '2025-08-14T07:11:13.169672+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = 'a74c9644-d569-493a-a0ac-3f59d864ba9f');

-- ensure reservation for 9017acf3-82c8-4296-b498-d4009810fa4f
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '9017acf3-82c8-4296-b498-d4009810fa4f', '810c0db7-c600-4c58-8909-cf5028f01b7e', 'd141e9e4-9122-4bc7-91cd-e4cea1fe64c6', 'car', 'confirmed', '2025-08-14T07:11:12.588246+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '9017acf3-82c8-4296-b498-d4009810fa4f');
UPDATE reservation SET re_quote_id = 'd141e9e4-9122-4bc7-91cd-e4cea1fe64c6', re_type = 'car'
WHERE re_id = '9017acf3-82c8-4296-b498-d4009810fa4f' AND (re_quote_id IS DISTINCT FROM 'd141e9e4-9122-4bc7-91cd-e4cea1fe64c6' OR re_type <> 'car');
-- reservation_cruise_car for reservation 9017acf3-82c8-4296-b498-d4009810fa4f
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '9017acf3-82c8-4296-b498-d4009810fa4f', '2025-08-14T07:11:12.588246+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '9017acf3-82c8-4296-b498-d4009810fa4f');

-- ensure reservation for 1458ecab-8435-4b0c-a9ab-37196118fe1e
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '1458ecab-8435-4b0c-a9ab-37196118fe1e', '6350d500-c1b4-4d1e-82ac-c66efac44439', '008c6993-f1b7-48ca-9b38-405d57e639e7', 'car', 'confirmed', '2025-08-14T07:11:11.972764+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '1458ecab-8435-4b0c-a9ab-37196118fe1e');
UPDATE reservation SET re_quote_id = '008c6993-f1b7-48ca-9b38-405d57e639e7', re_type = 'car'
WHERE re_id = '1458ecab-8435-4b0c-a9ab-37196118fe1e' AND (re_quote_id IS DISTINCT FROM '008c6993-f1b7-48ca-9b38-405d57e639e7' OR re_type <> 'car');
-- reservation_cruise_car for reservation 1458ecab-8435-4b0c-a9ab-37196118fe1e
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '1458ecab-8435-4b0c-a9ab-37196118fe1e', '2025-08-14T07:11:11.972764+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '1458ecab-8435-4b0c-a9ab-37196118fe1e');

-- ensure reservation for 40d52494-8b7c-4427-91d3-86d5fd72fcda
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '40d52494-8b7c-4427-91d3-86d5fd72fcda', 'b998b2ed-67c2-49e8-b695-4edbcb342870', '980e2547-a0a9-42dc-847c-d5ff04f1079b', 'car', 'confirmed', '2025-08-14T07:11:09.709031+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '40d52494-8b7c-4427-91d3-86d5fd72fcda');
UPDATE reservation SET re_quote_id = '980e2547-a0a9-42dc-847c-d5ff04f1079b', re_type = 'car'
WHERE re_id = '40d52494-8b7c-4427-91d3-86d5fd72fcda' AND (re_quote_id IS DISTINCT FROM '980e2547-a0a9-42dc-847c-d5ff04f1079b' OR re_type <> 'car');
-- reservation_cruise_car for reservation 40d52494-8b7c-4427-91d3-86d5fd72fcda
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '40d52494-8b7c-4427-91d3-86d5fd72fcda', '2025-08-14T07:11:09.709031+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '40d52494-8b7c-4427-91d3-86d5fd72fcda');

-- ensure reservation for 0a3c4624-c685-4531-9d48-1868742be591
INSERT INTO reservation (re_id, re_user_id, re_quote_id, re_type, re_status, re_created_at)
SELECT '0a3c4624-c685-4531-9d48-1868742be591', 'b998b2ed-67c2-49e8-b695-4edbcb342870', '980e2547-a0a9-42dc-847c-d5ff04f1079b', 'car', 'confirmed', '2025-08-14T07:11:09.117715+00:00'
WHERE NOT EXISTS (SELECT 1 FROM reservation WHERE re_id = '0a3c4624-c685-4531-9d48-1868742be591');
UPDATE reservation SET re_quote_id = '980e2547-a0a9-42dc-847c-d5ff04f1079b', re_type = 'car'
WHERE re_id = '0a3c4624-c685-4531-9d48-1868742be591' AND (re_quote_id IS DISTINCT FROM '980e2547-a0a9-42dc-847c-d5ff04f1079b' OR re_type <> 'car');
-- reservation_cruise_car for reservation 0a3c4624-c685-4531-9d48-1868742be591
INSERT INTO reservation_cruise_car (reservation_id, pickup_datetime, car_price_code)
SELECT '0a3c4624-c685-4531-9d48-1868742be591', '2025-08-14T07:11:09.117715+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_cruise_car WHERE reservation_id = '0a3c4624-c685-4531-9d48-1868742be591');

COMMIT;
