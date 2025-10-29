-- Auto-generated SQL to insert minimal missing service-detail rows
-- Review carefully before running. This script uses re_created_at as a fallback datetime where explicit service dates are absent.
-- Run in a transaction and/or on a replica for verification.

BEGIN;

-- reservation_car_sht for reservation e654207c-d276-4215-a41d-a23671c08f7e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e654207c-d276-4215-a41d-a23671c08f7e', '2025-08-15T13:10:01.697+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e654207c-d276-4215-a41d-a23671c08f7e');

-- reservation_car_sht for reservation 835ee2a4-58f1-4cc6-b6ba-e679fb4d3cec
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '835ee2a4-58f1-4cc6-b6ba-e679fb4d3cec', '2025-08-15T13:10:01.611+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '835ee2a4-58f1-4cc6-b6ba-e679fb4d3cec');

-- reservation_car_sht for reservation 9cc22847-58e6-4e8d-8d5f-fb37423dd5c8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9cc22847-58e6-4e8d-8d5f-fb37423dd5c8', '2025-08-15T13:10:01.518+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9cc22847-58e6-4e8d-8d5f-fb37423dd5c8');

-- reservation_car_sht for reservation b3827481-9ec5-46c5-81fe-70edc85d41a6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b3827481-9ec5-46c5-81fe-70edc85d41a6', '2025-08-15T13:10:01.429+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b3827481-9ec5-46c5-81fe-70edc85d41a6');

-- reservation_car_sht for reservation b3c65bec-05c5-4c48-857e-4d25246ae510
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b3c65bec-05c5-4c48-857e-4d25246ae510', '2025-08-15T13:10:01.351+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b3c65bec-05c5-4c48-857e-4d25246ae510');

-- reservation_car_sht for reservation db567513-658f-44a1-a49d-900092863b32
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'db567513-658f-44a1-a49d-900092863b32', '2025-08-15T13:10:01.277+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'db567513-658f-44a1-a49d-900092863b32');

-- reservation_car_sht for reservation 1496efb6-c878-4519-879a-499b9bca0897
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1496efb6-c878-4519-879a-499b9bca0897', '2025-08-15T13:10:01.182+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1496efb6-c878-4519-879a-499b9bca0897');

-- reservation_car_sht for reservation 221baedb-49ff-4c44-a708-ec3418c564c2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '221baedb-49ff-4c44-a708-ec3418c564c2', '2025-08-15T13:10:01.087+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '221baedb-49ff-4c44-a708-ec3418c564c2');

-- reservation_car_sht for reservation 4055fc90-fd21-4fb2-a198-fe375ee0510c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4055fc90-fd21-4fb2-a198-fe375ee0510c', '2025-08-15T13:10:00.992+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4055fc90-fd21-4fb2-a198-fe375ee0510c');

-- reservation_car_sht for reservation 4fe85819-a397-4a55-ac90-6519f64b1747
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4fe85819-a397-4a55-ac90-6519f64b1747', '2025-08-15T13:10:00.9+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4fe85819-a397-4a55-ac90-6519f64b1747');

-- reservation_car_sht for reservation ef8c8b7c-4fed-443d-ba1c-f9cc56942370
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ef8c8b7c-4fed-443d-ba1c-f9cc56942370', '2025-08-15T13:10:00.811+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ef8c8b7c-4fed-443d-ba1c-f9cc56942370');

-- reservation_car_sht for reservation 490a466f-3fc0-4df4-a6d2-fd936b499d75
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '490a466f-3fc0-4df4-a6d2-fd936b499d75', '2025-08-15T13:10:00.712+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '490a466f-3fc0-4df4-a6d2-fd936b499d75');

-- reservation_car_sht for reservation 468f0542-8208-42a1-aa58-6047ccd0306e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '468f0542-8208-42a1-aa58-6047ccd0306e', '2025-08-15T13:10:00.639+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '468f0542-8208-42a1-aa58-6047ccd0306e');

-- reservation_car_sht for reservation bc7d5074-f433-4087-bc94-cb1b2ec24faf
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'bc7d5074-f433-4087-bc94-cb1b2ec24faf', '2025-08-15T13:10:00.547+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'bc7d5074-f433-4087-bc94-cb1b2ec24faf');

-- reservation_car_sht for reservation 5f80951a-0147-45ef-8b27-d40f4980bb3f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5f80951a-0147-45ef-8b27-d40f4980bb3f', '2025-08-15T13:10:00.392+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5f80951a-0147-45ef-8b27-d40f4980bb3f');

-- reservation_car_sht for reservation db4b3ba8-db4e-4c51-b2b8-de6140a6bda3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'db4b3ba8-db4e-4c51-b2b8-de6140a6bda3', '2025-08-15T13:10:00.316+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'db4b3ba8-db4e-4c51-b2b8-de6140a6bda3');

-- reservation_car_sht for reservation 496c6d5f-b87f-4a38-b844-46ec1d3a708d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '496c6d5f-b87f-4a38-b844-46ec1d3a708d', '2025-08-15T13:10:00.216+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '496c6d5f-b87f-4a38-b844-46ec1d3a708d');

-- reservation_car_sht for reservation eb12303f-6366-42fd-86e0-72078921d678
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'eb12303f-6366-42fd-86e0-72078921d678', '2025-08-15T13:10:00.113+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'eb12303f-6366-42fd-86e0-72078921d678');

-- reservation_car_sht for reservation d0695167-8ad1-46f0-b982-574697d0ba0f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd0695167-8ad1-46f0-b982-574697d0ba0f', '2025-08-15T13:10:00.024+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd0695167-8ad1-46f0-b982-574697d0ba0f');

-- reservation_car_sht for reservation 746781c3-49e6-44fb-87c8-21e34e7a7b19
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '746781c3-49e6-44fb-87c8-21e34e7a7b19', '2025-08-15T13:09:59.947+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '746781c3-49e6-44fb-87c8-21e34e7a7b19');

-- reservation_car_sht for reservation c95569b8-38d3-4b54-b14c-04dd23039b9f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c95569b8-38d3-4b54-b14c-04dd23039b9f', '2025-08-15T13:09:59.874+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c95569b8-38d3-4b54-b14c-04dd23039b9f');

-- reservation_car_sht for reservation a273fea6-d16b-488c-8afb-5b389aeea10b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a273fea6-d16b-488c-8afb-5b389aeea10b', '2025-08-15T13:09:59.793+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a273fea6-d16b-488c-8afb-5b389aeea10b');

-- reservation_car_sht for reservation d2532702-bc0a-4f7c-919e-9c25b7a31ce1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd2532702-bc0a-4f7c-919e-9c25b7a31ce1', '2025-08-15T13:09:59.711+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd2532702-bc0a-4f7c-919e-9c25b7a31ce1');

-- reservation_car_sht for reservation 1b8da538-cc2d-4cec-a91b-c73bd5850085
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1b8da538-cc2d-4cec-a91b-c73bd5850085', '2025-08-15T13:09:59.597+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1b8da538-cc2d-4cec-a91b-c73bd5850085');

-- reservation_car_sht for reservation 060fbb30-6809-4958-aece-c3fa86a66c29
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '060fbb30-6809-4958-aece-c3fa86a66c29', '2025-08-15T13:09:59.481+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '060fbb30-6809-4958-aece-c3fa86a66c29');

-- reservation_car_sht for reservation 9f54045d-4132-4f87-a50f-cd86762c5dc1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9f54045d-4132-4f87-a50f-cd86762c5dc1', '2025-08-15T13:09:59.396+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9f54045d-4132-4f87-a50f-cd86762c5dc1');

-- reservation_car_sht for reservation 563882f8-6e39-4ae3-a7c1-a69547897b35
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '563882f8-6e39-4ae3-a7c1-a69547897b35', '2025-08-15T13:09:59.314+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '563882f8-6e39-4ae3-a7c1-a69547897b35');

-- reservation_car_sht for reservation b5affd23-09a6-4722-a7c5-a4a6b53bfa67
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b5affd23-09a6-4722-a7c5-a4a6b53bfa67', '2025-08-15T13:09:59.242+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b5affd23-09a6-4722-a7c5-a4a6b53bfa67');

-- reservation_car_sht for reservation 48380699-9a2d-40f6-b6d0-413ae355b190
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '48380699-9a2d-40f6-b6d0-413ae355b190', '2025-08-15T13:09:59.158+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '48380699-9a2d-40f6-b6d0-413ae355b190');

-- reservation_car_sht for reservation 8eaf8ff8-e091-4c27-9474-34bb537a3670
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8eaf8ff8-e091-4c27-9474-34bb537a3670', '2025-08-15T13:09:59.066+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8eaf8ff8-e091-4c27-9474-34bb537a3670');

-- reservation_car_sht for reservation c4af837b-bd73-4c45-b78a-6de735d3c056
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c4af837b-bd73-4c45-b78a-6de735d3c056', '2025-08-15T13:09:58.977+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c4af837b-bd73-4c45-b78a-6de735d3c056');

-- reservation_car_sht for reservation 6f52fd43-3b64-449c-a600-11edd5e3853e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6f52fd43-3b64-449c-a600-11edd5e3853e', '2025-08-15T13:09:58.871+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6f52fd43-3b64-449c-a600-11edd5e3853e');

-- reservation_car_sht for reservation 1cde2a8c-a79b-4b06-967c-ed6c9f602c0c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1cde2a8c-a79b-4b06-967c-ed6c9f602c0c', '2025-08-15T13:09:58.778+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1cde2a8c-a79b-4b06-967c-ed6c9f602c0c');

-- reservation_car_sht for reservation 149e1fad-9059-423a-a284-acd1e4a2fc91
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '149e1fad-9059-423a-a284-acd1e4a2fc91', '2025-08-15T13:09:58.669+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '149e1fad-9059-423a-a284-acd1e4a2fc91');

-- reservation_car_sht for reservation 4ab20778-a3c9-45bd-a5cb-0d9830dfbd1c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4ab20778-a3c9-45bd-a5cb-0d9830dfbd1c', '2025-08-15T13:09:58.578+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4ab20778-a3c9-45bd-a5cb-0d9830dfbd1c');

-- reservation_car_sht for reservation b56387f4-7f1a-49c9-8c14-f70fca75456d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b56387f4-7f1a-49c9-8c14-f70fca75456d', '2025-08-15T13:09:58.447+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b56387f4-7f1a-49c9-8c14-f70fca75456d');

-- reservation_car_sht for reservation 676447a0-7fc0-4cee-a475-81cc1a1ec1cd
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '676447a0-7fc0-4cee-a475-81cc1a1ec1cd', '2025-08-15T13:09:58.338+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '676447a0-7fc0-4cee-a475-81cc1a1ec1cd');

-- reservation_car_sht for reservation 80f14dc9-eace-4e0e-b5d0-6df4a26ac642
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '80f14dc9-eace-4e0e-b5d0-6df4a26ac642', '2025-08-15T13:09:58.257+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '80f14dc9-eace-4e0e-b5d0-6df4a26ac642');

-- reservation_car_sht for reservation b564b438-0ef2-45a5-83ae-be017c0141f6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b564b438-0ef2-45a5-83ae-be017c0141f6', '2025-08-15T13:09:58.142+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b564b438-0ef2-45a5-83ae-be017c0141f6');

-- reservation_car_sht for reservation a2f58cb9-cbdb-4f64-bc0b-85facba07dd4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a2f58cb9-cbdb-4f64-bc0b-85facba07dd4', '2025-08-15T13:09:58.042+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a2f58cb9-cbdb-4f64-bc0b-85facba07dd4');

-- reservation_car_sht for reservation 662c5198-f431-4d0c-9d98-823c8d312394
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '662c5198-f431-4d0c-9d98-823c8d312394', '2025-08-15T13:09:57.938+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '662c5198-f431-4d0c-9d98-823c8d312394');

-- reservation_car_sht for reservation 23e10a48-2977-4512-b1bc-9d500c47a4ab
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '23e10a48-2977-4512-b1bc-9d500c47a4ab', '2025-08-15T13:09:57.858+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '23e10a48-2977-4512-b1bc-9d500c47a4ab');

-- reservation_car_sht for reservation 22b6487e-4f6a-43d7-8e21-f8c736e124f1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '22b6487e-4f6a-43d7-8e21-f8c736e124f1', '2025-08-15T13:09:57.736+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '22b6487e-4f6a-43d7-8e21-f8c736e124f1');

-- reservation_car_sht for reservation fd6034aa-7cb6-49df-8a91-1494d8a761df
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'fd6034aa-7cb6-49df-8a91-1494d8a761df', '2025-08-15T13:09:57.653+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'fd6034aa-7cb6-49df-8a91-1494d8a761df');

-- reservation_car_sht for reservation ef2adaeb-dc40-42a3-88d9-5af7d247f15c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ef2adaeb-dc40-42a3-88d9-5af7d247f15c', '2025-08-15T13:09:57.568+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ef2adaeb-dc40-42a3-88d9-5af7d247f15c');

-- reservation_car_sht for reservation 3af1d76d-fb61-4e45-b966-036f3fd8bd68
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3af1d76d-fb61-4e45-b966-036f3fd8bd68', '2025-08-15T13:09:57.473+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3af1d76d-fb61-4e45-b966-036f3fd8bd68');

-- reservation_car_sht for reservation d6076397-d252-4e4c-afc4-926c482f56cd
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd6076397-d252-4e4c-afc4-926c482f56cd', '2025-08-15T13:09:57.359+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd6076397-d252-4e4c-afc4-926c482f56cd');

-- reservation_car_sht for reservation 98b65a68-974a-495f-b901-39dac4fa627e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '98b65a68-974a-495f-b901-39dac4fa627e', '2025-08-15T13:09:57.268+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '98b65a68-974a-495f-b901-39dac4fa627e');

-- reservation_car_sht for reservation 942439bb-2bb7-4c03-b47d-9270bb77d094
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '942439bb-2bb7-4c03-b47d-9270bb77d094', '2025-08-15T13:09:57.201+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '942439bb-2bb7-4c03-b47d-9270bb77d094');

-- reservation_car_sht for reservation 650a6fb8-a0db-45b0-8fbe-01a2a72e67d5
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '650a6fb8-a0db-45b0-8fbe-01a2a72e67d5', '2025-08-15T13:09:57.101+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '650a6fb8-a0db-45b0-8fbe-01a2a72e67d5');

-- reservation_car_sht for reservation 96e0bea0-eb16-49b4-a9c2-50d30bd2412f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '96e0bea0-eb16-49b4-a9c2-50d30bd2412f', '2025-08-15T13:09:56.996+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '96e0bea0-eb16-49b4-a9c2-50d30bd2412f');

-- reservation_car_sht for reservation 4143a04f-f4e4-4925-9430-6c7885c30a2f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4143a04f-f4e4-4925-9430-6c7885c30a2f', '2025-08-15T13:09:56.917+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4143a04f-f4e4-4925-9430-6c7885c30a2f');

-- reservation_car_sht for reservation 7e384ea3-ff62-4f56-8828-0bfd9f9bd1d0
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7e384ea3-ff62-4f56-8828-0bfd9f9bd1d0', '2025-08-15T13:09:56.83+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7e384ea3-ff62-4f56-8828-0bfd9f9bd1d0');

-- reservation_car_sht for reservation 88dde575-fcc8-45e6-9309-08557756f7f8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '88dde575-fcc8-45e6-9309-08557756f7f8', '2025-08-15T13:09:56.724+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '88dde575-fcc8-45e6-9309-08557756f7f8');

-- reservation_car_sht for reservation 0074789d-c038-48c8-9b6c-1c9590d25e04
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0074789d-c038-48c8-9b6c-1c9590d25e04', '2025-08-15T13:09:56.612+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0074789d-c038-48c8-9b6c-1c9590d25e04');

-- reservation_car_sht for reservation 8b2fa442-14b8-4d73-a33b-72e442a74f61
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8b2fa442-14b8-4d73-a33b-72e442a74f61', '2025-08-15T13:09:56.521+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8b2fa442-14b8-4d73-a33b-72e442a74f61');

-- reservation_car_sht for reservation fcbc45c3-39f9-4143-ac5d-e7de0c16d5d4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'fcbc45c3-39f9-4143-ac5d-e7de0c16d5d4', '2025-08-15T13:09:56.447+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'fcbc45c3-39f9-4143-ac5d-e7de0c16d5d4');

-- reservation_car_sht for reservation bd3027ba-14e6-4c75-ab89-64d0a260d048
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'bd3027ba-14e6-4c75-ab89-64d0a260d048', '2025-08-15T13:09:56.326+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'bd3027ba-14e6-4c75-ab89-64d0a260d048');

-- reservation_car_sht for reservation 7f5bb1fb-f9b5-4640-a6b2-55fb8d76797d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7f5bb1fb-f9b5-4640-a6b2-55fb8d76797d', '2025-08-15T13:09:56.226+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7f5bb1fb-f9b5-4640-a6b2-55fb8d76797d');

-- reservation_car_sht for reservation 0ef2ad96-f2f6-46e7-bd51-c54b079f355b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0ef2ad96-f2f6-46e7-bd51-c54b079f355b', '2025-08-15T13:09:56.121+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0ef2ad96-f2f6-46e7-bd51-c54b079f355b');

-- reservation_car_sht for reservation c9859d94-ec14-4e84-8bfb-2552f71a7790
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c9859d94-ec14-4e84-8bfb-2552f71a7790', '2025-08-15T13:09:55.984+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c9859d94-ec14-4e84-8bfb-2552f71a7790');

-- reservation_car_sht for reservation cdaa24f2-9f0c-456d-8e68-33f2e101a4cf
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'cdaa24f2-9f0c-456d-8e68-33f2e101a4cf', '2025-08-15T13:09:55.875+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'cdaa24f2-9f0c-456d-8e68-33f2e101a4cf');

-- reservation_car_sht for reservation 6e03261a-8de1-497e-88c6-e0fd665827d4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6e03261a-8de1-497e-88c6-e0fd665827d4', '2025-08-15T13:09:55.795+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6e03261a-8de1-497e-88c6-e0fd665827d4');

-- reservation_car_sht for reservation 046652d9-744c-4504-896f-ac0f8dc14389
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '046652d9-744c-4504-896f-ac0f8dc14389', '2025-08-15T13:09:55.688+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '046652d9-744c-4504-896f-ac0f8dc14389');

-- reservation_car_sht for reservation c20a21ef-3d35-48bc-9c0b-dc6e0099e438
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c20a21ef-3d35-48bc-9c0b-dc6e0099e438', '2025-08-15T13:09:55.607+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c20a21ef-3d35-48bc-9c0b-dc6e0099e438');

-- reservation_car_sht for reservation 769289df-b882-4429-8a13-d3244ddaab4c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '769289df-b882-4429-8a13-d3244ddaab4c', '2025-08-15T13:09:55.444+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '769289df-b882-4429-8a13-d3244ddaab4c');

-- reservation_car_sht for reservation 5da9b528-233d-4883-9c21-cd7405b58109
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5da9b528-233d-4883-9c21-cd7405b58109', '2025-08-15T13:09:55.355+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5da9b528-233d-4883-9c21-cd7405b58109');

-- reservation_car_sht for reservation 5d4753d3-3b38-4f98-8ee6-ec972dc5ef18
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5d4753d3-3b38-4f98-8ee6-ec972dc5ef18', '2025-08-15T13:09:55.236+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5d4753d3-3b38-4f98-8ee6-ec972dc5ef18');

-- reservation_car_sht for reservation aff6e3af-b635-487a-9ea0-7aefefbedb3d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'aff6e3af-b635-487a-9ea0-7aefefbedb3d', '2025-08-15T13:09:55.137+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'aff6e3af-b635-487a-9ea0-7aefefbedb3d');

-- reservation_car_sht for reservation 0855b375-082b-4848-bcac-3bdf40cf2ada
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0855b375-082b-4848-bcac-3bdf40cf2ada', '2025-08-15T13:09:55.029+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0855b375-082b-4848-bcac-3bdf40cf2ada');

-- reservation_car_sht for reservation 9b438ce5-65f0-4647-8aff-914428e3d438
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9b438ce5-65f0-4647-8aff-914428e3d438', '2025-08-15T13:09:54.941+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9b438ce5-65f0-4647-8aff-914428e3d438');

-- reservation_car_sht for reservation bcd65e13-d344-4ed1-9041-b7f142bfefff
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'bcd65e13-d344-4ed1-9041-b7f142bfefff', '2025-08-15T13:09:54.866+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'bcd65e13-d344-4ed1-9041-b7f142bfefff');

-- reservation_car_sht for reservation 88b0dd03-0ad7-4872-a7f1-a182117491fa
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '88b0dd03-0ad7-4872-a7f1-a182117491fa', '2025-08-15T13:09:54.797+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '88b0dd03-0ad7-4872-a7f1-a182117491fa');

-- reservation_car_sht for reservation 3b283436-bf00-4811-98cb-c5e90c78545a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3b283436-bf00-4811-98cb-c5e90c78545a', '2025-08-15T13:09:54.704+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3b283436-bf00-4811-98cb-c5e90c78545a');

-- reservation_car_sht for reservation 323eda18-e5eb-43a2-bc79-e38fcaa751ff
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '323eda18-e5eb-43a2-bc79-e38fcaa751ff', '2025-08-15T13:09:54.627+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '323eda18-e5eb-43a2-bc79-e38fcaa751ff');

-- reservation_car_sht for reservation 537921fb-1813-4afe-9bdb-277e7647f82d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '537921fb-1813-4afe-9bdb-277e7647f82d', '2025-08-15T13:09:54.533+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '537921fb-1813-4afe-9bdb-277e7647f82d');

-- reservation_car_sht for reservation 76a1c189-078b-4f11-95d5-a4a445c5c168
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '76a1c189-078b-4f11-95d5-a4a445c5c168', '2025-08-15T13:09:54.463+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '76a1c189-078b-4f11-95d5-a4a445c5c168');

-- reservation_car_sht for reservation 1a9ddc88-b8e2-47bf-846b-eaf2fe10578f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1a9ddc88-b8e2-47bf-846b-eaf2fe10578f', '2025-08-15T13:09:54.384+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1a9ddc88-b8e2-47bf-846b-eaf2fe10578f');

-- reservation_car_sht for reservation 1f2785ae-4f3b-484f-9e6c-14b6d1722fc9
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1f2785ae-4f3b-484f-9e6c-14b6d1722fc9', '2025-08-15T13:09:54.311+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1f2785ae-4f3b-484f-9e6c-14b6d1722fc9');

-- reservation_car_sht for reservation 0c346e3c-938a-4220-ac88-7918fb81f774
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0c346e3c-938a-4220-ac88-7918fb81f774', '2025-08-15T13:09:54.226+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0c346e3c-938a-4220-ac88-7918fb81f774');

-- reservation_car_sht for reservation 385a94de-54d2-463d-b59d-c1bcf7e8cd7e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '385a94de-54d2-463d-b59d-c1bcf7e8cd7e', '2025-08-15T13:09:54.148+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '385a94de-54d2-463d-b59d-c1bcf7e8cd7e');

-- reservation_car_sht for reservation 36e11c4e-8847-45b6-914f-3e1204a8197f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '36e11c4e-8847-45b6-914f-3e1204a8197f', '2025-08-15T13:09:54.056+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '36e11c4e-8847-45b6-914f-3e1204a8197f');

-- reservation_car_sht for reservation b92f7db2-110f-4e2b-aa84-21ce8e220b24
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b92f7db2-110f-4e2b-aa84-21ce8e220b24', '2025-08-15T13:09:53.975+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b92f7db2-110f-4e2b-aa84-21ce8e220b24');

-- reservation_car_sht for reservation a13c2640-3d3a-4e45-a5f1-d6cd90cadae7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a13c2640-3d3a-4e45-a5f1-d6cd90cadae7', '2025-08-15T13:09:53.881+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a13c2640-3d3a-4e45-a5f1-d6cd90cadae7');

-- reservation_car_sht for reservation e8affbd5-60b2-4c3c-90a6-03a2e5dea495
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e8affbd5-60b2-4c3c-90a6-03a2e5dea495', '2025-08-15T13:09:53.789+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e8affbd5-60b2-4c3c-90a6-03a2e5dea495');

-- reservation_car_sht for reservation 2b239775-3818-410e-9158-303c214243fb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '2b239775-3818-410e-9158-303c214243fb', '2025-08-15T13:09:53.699+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '2b239775-3818-410e-9158-303c214243fb');

-- reservation_car_sht for reservation 6dca042c-73cd-44ab-8db5-8e4b1565f2b2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6dca042c-73cd-44ab-8db5-8e4b1565f2b2', '2025-08-15T13:09:53.624+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6dca042c-73cd-44ab-8db5-8e4b1565f2b2');

-- reservation_car_sht for reservation bee41bda-772a-4753-bb99-4a139729ecf1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'bee41bda-772a-4753-bb99-4a139729ecf1', '2025-08-15T13:09:53.527+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'bee41bda-772a-4753-bb99-4a139729ecf1');

-- reservation_car_sht for reservation 4024de03-f55c-4ef1-aabd-7bde7b8dc02e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4024de03-f55c-4ef1-aabd-7bde7b8dc02e', '2025-08-15T13:09:53.424+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4024de03-f55c-4ef1-aabd-7bde7b8dc02e');

-- reservation_car_sht for reservation 103322c5-648a-4744-abbb-8c19a8eab03d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '103322c5-648a-4744-abbb-8c19a8eab03d', '2025-08-15T13:09:53.329+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '103322c5-648a-4744-abbb-8c19a8eab03d');

-- reservation_car_sht for reservation d5e515cd-9b0a-4667-a8f5-614ee16012d3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd5e515cd-9b0a-4667-a8f5-614ee16012d3', '2025-08-15T13:09:53.245+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd5e515cd-9b0a-4667-a8f5-614ee16012d3');

-- reservation_car_sht for reservation 09bb373e-d937-4e5f-ae11-38a89b72fe33
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '09bb373e-d937-4e5f-ae11-38a89b72fe33', '2025-08-15T13:09:53.12+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '09bb373e-d937-4e5f-ae11-38a89b72fe33');

-- reservation_car_sht for reservation f35c543b-50fb-4d79-b748-e6959e63d864
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f35c543b-50fb-4d79-b748-e6959e63d864', '2025-08-15T13:09:53.022+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f35c543b-50fb-4d79-b748-e6959e63d864');

-- reservation_car_sht for reservation 9b0b8528-d8aa-42e6-b3a7-3fc7e1e484c6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9b0b8528-d8aa-42e6-b3a7-3fc7e1e484c6', '2025-08-15T13:09:52.948+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9b0b8528-d8aa-42e6-b3a7-3fc7e1e484c6');

-- reservation_car_sht for reservation 8ca2a48d-b550-4089-8b57-9f85d954b6af
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8ca2a48d-b550-4089-8b57-9f85d954b6af', '2025-08-15T13:09:52.876+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8ca2a48d-b550-4089-8b57-9f85d954b6af');

-- reservation_car_sht for reservation ffbd5c43-6240-4f68-a8a8-407ee3b546b1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ffbd5c43-6240-4f68-a8a8-407ee3b546b1', '2025-08-15T13:09:52.796+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ffbd5c43-6240-4f68-a8a8-407ee3b546b1');

-- reservation_car_sht for reservation 9a529aaf-7a02-4159-8e87-883bedd550dd
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9a529aaf-7a02-4159-8e87-883bedd550dd', '2025-08-15T13:09:52.709+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9a529aaf-7a02-4159-8e87-883bedd550dd');

-- reservation_car_sht for reservation 734f7749-f59e-4d2c-a142-cfd75115de6b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '734f7749-f59e-4d2c-a142-cfd75115de6b', '2025-08-15T13:09:52.611+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '734f7749-f59e-4d2c-a142-cfd75115de6b');

-- reservation_car_sht for reservation 4e0294a4-baad-4021-a757-8b7929f9ae7b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4e0294a4-baad-4021-a757-8b7929f9ae7b', '2025-08-15T13:09:52.53+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4e0294a4-baad-4021-a757-8b7929f9ae7b');

-- reservation_car_sht for reservation a2eae180-d760-4616-bf11-ccfd5e9a14ee
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a2eae180-d760-4616-bf11-ccfd5e9a14ee', '2025-08-15T13:09:52.424+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a2eae180-d760-4616-bf11-ccfd5e9a14ee');

COMMIT;
