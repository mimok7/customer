-- Auto-generated SQL to insert minimal missing service-detail rows
-- Review carefully before running. This script uses re_created_at as a fallback datetime where explicit service dates are absent.
-- Run in a transaction and/or on a replica for verification.

BEGIN;

-- reservation_car_sht for reservation f345ef90-80c3-4ef8-bd24-e44ff32bdf71
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f345ef90-80c3-4ef8-bd24-e44ff32bdf71', '2025-08-15T13:10:20.336+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f345ef90-80c3-4ef8-bd24-e44ff32bdf71');

-- reservation_car_sht for reservation ed643272-3bbc-4f84-abae-2855535aa5e7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ed643272-3bbc-4f84-abae-2855535aa5e7', '2025-08-15T13:10:20.23+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ed643272-3bbc-4f84-abae-2855535aa5e7');

-- reservation_car_sht for reservation edcba980-6f6a-4815-b7b8-7074e3a897d6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'edcba980-6f6a-4815-b7b8-7074e3a897d6', '2025-08-15T13:10:20.123+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'edcba980-6f6a-4815-b7b8-7074e3a897d6');

-- reservation_car_sht for reservation c8961d5a-10d7-40a7-8d36-7c54bec11edc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c8961d5a-10d7-40a7-8d36-7c54bec11edc', '2025-08-15T13:10:20.001+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c8961d5a-10d7-40a7-8d36-7c54bec11edc');

-- reservation_car_sht for reservation e45c7d76-1cb2-47d0-ad57-a503d4c487de
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e45c7d76-1cb2-47d0-ad57-a503d4c487de', '2025-08-15T13:10:19.915+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e45c7d76-1cb2-47d0-ad57-a503d4c487de');

-- reservation_car_sht for reservation 5142ff45-51df-49a0-ad13-5559b7ab216c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5142ff45-51df-49a0-ad13-5559b7ab216c', '2025-08-15T13:10:19.81+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5142ff45-51df-49a0-ad13-5559b7ab216c');

-- reservation_car_sht for reservation d2e6ef86-02ab-4d27-b55a-d25d387b7416
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd2e6ef86-02ab-4d27-b55a-d25d387b7416', '2025-08-15T13:10:19.721+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd2e6ef86-02ab-4d27-b55a-d25d387b7416');

-- reservation_car_sht for reservation 7d2fb3f8-cacd-450c-b4ec-207f169c4f34
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7d2fb3f8-cacd-450c-b4ec-207f169c4f34', '2025-08-15T13:10:19.603+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7d2fb3f8-cacd-450c-b4ec-207f169c4f34');

-- reservation_car_sht for reservation 4f1ce0d0-1f2c-47af-8da9-c4c7d789114d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4f1ce0d0-1f2c-47af-8da9-c4c7d789114d', '2025-08-15T13:10:19.512+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4f1ce0d0-1f2c-47af-8da9-c4c7d789114d');

-- reservation_car_sht for reservation d230501d-a81d-4e67-b1c2-cc1a8f17d0b1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd230501d-a81d-4e67-b1c2-cc1a8f17d0b1', '2025-08-15T13:10:19.412+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd230501d-a81d-4e67-b1c2-cc1a8f17d0b1');

-- reservation_car_sht for reservation d7bcb8c7-bdaf-4553-b252-8714f93fac7c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd7bcb8c7-bdaf-4553-b252-8714f93fac7c', '2025-08-15T13:10:19.307+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd7bcb8c7-bdaf-4553-b252-8714f93fac7c');

-- reservation_car_sht for reservation 541f7c65-62a2-44f1-8385-4a48373b7f3b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '541f7c65-62a2-44f1-8385-4a48373b7f3b', '2025-08-15T13:10:19.214+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '541f7c65-62a2-44f1-8385-4a48373b7f3b');

-- reservation_car_sht for reservation f45b2b75-8f36-4350-b7b5-fae55e8c1ce6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f45b2b75-8f36-4350-b7b5-fae55e8c1ce6', '2025-08-15T13:10:19.133+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f45b2b75-8f36-4350-b7b5-fae55e8c1ce6');

-- reservation_car_sht for reservation aacf18aa-2a4b-4c21-b6a6-3e06a7886232
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'aacf18aa-2a4b-4c21-b6a6-3e06a7886232', '2025-08-15T13:10:19.03+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'aacf18aa-2a4b-4c21-b6a6-3e06a7886232');

-- reservation_car_sht for reservation 6f6b7610-bd1f-49db-af0b-dda401c09cf3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6f6b7610-bd1f-49db-af0b-dda401c09cf3', '2025-08-15T13:10:18.934+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6f6b7610-bd1f-49db-af0b-dda401c09cf3');

-- reservation_car_sht for reservation e6c67f3b-4e85-4331-8f72-fb2ef126648e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e6c67f3b-4e85-4331-8f72-fb2ef126648e', '2025-08-15T13:10:18.82+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e6c67f3b-4e85-4331-8f72-fb2ef126648e');

-- reservation_car_sht for reservation d7c6a280-368f-4aa7-8391-7cff3c5ca30b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd7c6a280-368f-4aa7-8391-7cff3c5ca30b', '2025-08-15T13:10:18.739+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd7c6a280-368f-4aa7-8391-7cff3c5ca30b');

-- reservation_car_sht for reservation ce7ad21a-625e-4c7a-869c-baaf1ffb06e0
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ce7ad21a-625e-4c7a-869c-baaf1ffb06e0', '2025-08-15T13:10:18.627+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ce7ad21a-625e-4c7a-869c-baaf1ffb06e0');

-- reservation_car_sht for reservation a417b887-c724-4133-8641-ca5cb2154360
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a417b887-c724-4133-8641-ca5cb2154360', '2025-08-15T13:10:18.524+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a417b887-c724-4133-8641-ca5cb2154360');

-- reservation_car_sht for reservation 9db6aae8-b3f7-41fa-a8e8-a05d0885a81e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9db6aae8-b3f7-41fa-a8e8-a05d0885a81e', '2025-08-15T13:10:18.404+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9db6aae8-b3f7-41fa-a8e8-a05d0885a81e');

-- reservation_car_sht for reservation e5b97b44-2df1-43db-b4c8-bbf48e10b912
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e5b97b44-2df1-43db-b4c8-bbf48e10b912', '2025-08-15T13:10:18.302+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e5b97b44-2df1-43db-b4c8-bbf48e10b912');

-- reservation_car_sht for reservation f0053c13-6bc4-460e-8671-b14728dd9968
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f0053c13-6bc4-460e-8671-b14728dd9968', '2025-08-15T13:10:18.162+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f0053c13-6bc4-460e-8671-b14728dd9968');

-- reservation_car_sht for reservation be260264-67f6-4cd3-9460-534aa00915c1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'be260264-67f6-4cd3-9460-534aa00915c1', '2025-08-15T13:10:18.081+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'be260264-67f6-4cd3-9460-534aa00915c1');

-- reservation_car_sht for reservation 1cb109e1-6b40-4b54-839e-df53385ab30a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1cb109e1-6b40-4b54-839e-df53385ab30a', '2025-08-15T13:10:17.991+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1cb109e1-6b40-4b54-839e-df53385ab30a');

-- reservation_car_sht for reservation 00fd2ac4-5637-4f7f-94e3-cd29870eb2d7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '00fd2ac4-5637-4f7f-94e3-cd29870eb2d7', '2025-08-15T13:10:17.908+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '00fd2ac4-5637-4f7f-94e3-cd29870eb2d7');

-- reservation_car_sht for reservation e59d7425-4e76-425d-b61a-f887e6e6b93b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e59d7425-4e76-425d-b61a-f887e6e6b93b', '2025-08-15T13:10:17.833+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e59d7425-4e76-425d-b61a-f887e6e6b93b');

-- reservation_car_sht for reservation 57ce996f-7323-4a74-ba1c-5725bdd1691a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '57ce996f-7323-4a74-ba1c-5725bdd1691a', '2025-08-15T13:10:17.745+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '57ce996f-7323-4a74-ba1c-5725bdd1691a');

-- reservation_car_sht for reservation 77d81db4-630a-482b-a988-bb7ebde71b16
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '77d81db4-630a-482b-a988-bb7ebde71b16', '2025-08-15T13:10:17.649+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '77d81db4-630a-482b-a988-bb7ebde71b16');

-- reservation_car_sht for reservation 728cbdd8-97bc-4c77-b3c5-4a6072a4dcb6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '728cbdd8-97bc-4c77-b3c5-4a6072a4dcb6', '2025-08-15T13:10:17.561+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '728cbdd8-97bc-4c77-b3c5-4a6072a4dcb6');

-- reservation_car_sht for reservation 0ce589cf-7657-4d88-beb6-de726dbaf87a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0ce589cf-7657-4d88-beb6-de726dbaf87a', '2025-08-15T13:10:17.475+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0ce589cf-7657-4d88-beb6-de726dbaf87a');

-- reservation_car_sht for reservation a965a2e2-a2f4-4c59-b77e-b6777aaa874b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a965a2e2-a2f4-4c59-b77e-b6777aaa874b', '2025-08-15T13:10:17.391+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a965a2e2-a2f4-4c59-b77e-b6777aaa874b');

-- reservation_car_sht for reservation c6485767-6d80-413d-8583-485dc763358a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c6485767-6d80-413d-8583-485dc763358a', '2025-08-15T13:10:17.313+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c6485767-6d80-413d-8583-485dc763358a');

-- reservation_car_sht for reservation c2401a0a-aaa1-462b-8fef-0c035b1644a5
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c2401a0a-aaa1-462b-8fef-0c035b1644a5', '2025-08-15T13:10:17.191+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c2401a0a-aaa1-462b-8fef-0c035b1644a5');

-- reservation_car_sht for reservation c94bce63-7ba1-463e-b69e-a2b485ba025a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c94bce63-7ba1-463e-b69e-a2b485ba025a', '2025-08-15T13:10:17.104+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c94bce63-7ba1-463e-b69e-a2b485ba025a');

-- reservation_car_sht for reservation ae0f08b2-e63e-4b16-89c2-bc853a1165ba
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ae0f08b2-e63e-4b16-89c2-bc853a1165ba', '2025-08-15T13:10:17.012+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ae0f08b2-e63e-4b16-89c2-bc853a1165ba');

-- reservation_car_sht for reservation e2961dc1-4f12-4a37-9f5a-9cd4745d1cf8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e2961dc1-4f12-4a37-9f5a-9cd4745d1cf8', '2025-08-15T13:10:16.908+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e2961dc1-4f12-4a37-9f5a-9cd4745d1cf8');

-- reservation_car_sht for reservation 6648b286-5733-4242-bb9a-495a215aff26
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6648b286-5733-4242-bb9a-495a215aff26', '2025-08-15T13:10:16.802+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6648b286-5733-4242-bb9a-495a215aff26');

-- reservation_car_sht for reservation 4b5ddf38-595a-49ed-b3ba-d1ae93ef3245
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4b5ddf38-595a-49ed-b3ba-d1ae93ef3245', '2025-08-15T13:10:16.704+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4b5ddf38-595a-49ed-b3ba-d1ae93ef3245');

-- reservation_car_sht for reservation 9830e4d8-f4dc-451e-aad0-280ab97a834a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9830e4d8-f4dc-451e-aad0-280ab97a834a', '2025-08-15T13:10:16.589+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9830e4d8-f4dc-451e-aad0-280ab97a834a');

-- reservation_car_sht for reservation ed38f2c5-e514-4eae-8b1e-614e7f79a5d0
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ed38f2c5-e514-4eae-8b1e-614e7f79a5d0', '2025-08-15T13:10:16.513+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ed38f2c5-e514-4eae-8b1e-614e7f79a5d0');

-- reservation_car_sht for reservation 5e287dc5-bd04-4664-be7b-6c51b2883b97
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5e287dc5-bd04-4664-be7b-6c51b2883b97', '2025-08-15T13:10:16.417+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5e287dc5-bd04-4664-be7b-6c51b2883b97');

-- reservation_car_sht for reservation c191835c-0a5e-464b-8f9a-943b4dda29e4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c191835c-0a5e-464b-8f9a-943b4dda29e4', '2025-08-15T13:10:16.303+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c191835c-0a5e-464b-8f9a-943b4dda29e4');

-- reservation_car_sht for reservation 383a36d6-1644-4c4d-be99-fbffe9e5effb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '383a36d6-1644-4c4d-be99-fbffe9e5effb', '2025-08-15T13:10:16.209+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '383a36d6-1644-4c4d-be99-fbffe9e5effb');

-- reservation_car_sht for reservation 35966c8e-8ff7-4caf-b865-597eb28ff631
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '35966c8e-8ff7-4caf-b865-597eb28ff631', '2025-08-15T13:10:16.113+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '35966c8e-8ff7-4caf-b865-597eb28ff631');

-- reservation_car_sht for reservation 593abd19-9f44-4d9c-a2df-71e606b44229
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '593abd19-9f44-4d9c-a2df-71e606b44229', '2025-08-15T13:10:16.02+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '593abd19-9f44-4d9c-a2df-71e606b44229');

-- reservation_car_sht for reservation 116ca8dd-1220-4ddd-9df7-e7347a66080f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '116ca8dd-1220-4ddd-9df7-e7347a66080f', '2025-08-15T13:10:15.921+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '116ca8dd-1220-4ddd-9df7-e7347a66080f');

-- reservation_car_sht for reservation c7f82ca6-6541-4e2d-82a3-5ababa069c39
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c7f82ca6-6541-4e2d-82a3-5ababa069c39', '2025-08-15T13:10:15.839+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c7f82ca6-6541-4e2d-82a3-5ababa069c39');

-- reservation_car_sht for reservation ac951402-4eda-479c-8784-66dac8eb38aa
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ac951402-4eda-479c-8784-66dac8eb38aa', '2025-08-15T13:10:15.746+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ac951402-4eda-479c-8784-66dac8eb38aa');

-- reservation_car_sht for reservation 441f3cbb-17e6-43c0-bfdf-6bd36c403f24
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '441f3cbb-17e6-43c0-bfdf-6bd36c403f24', '2025-08-15T13:10:15.616+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '441f3cbb-17e6-43c0-bfdf-6bd36c403f24');

-- reservation_car_sht for reservation b6407fd5-9139-4c77-9fb6-b387f6e30385
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b6407fd5-9139-4c77-9fb6-b387f6e30385', '2025-08-15T13:10:15.514+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b6407fd5-9139-4c77-9fb6-b387f6e30385');

-- reservation_car_sht for reservation 5507c747-4249-400c-bc72-0670e2f5d896
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5507c747-4249-400c-bc72-0670e2f5d896', '2025-08-15T13:10:15.42+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5507c747-4249-400c-bc72-0670e2f5d896');

-- reservation_car_sht for reservation 00beea17-c445-4faa-b8fd-db7f363b458c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '00beea17-c445-4faa-b8fd-db7f363b458c', '2025-08-15T13:10:15.342+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '00beea17-c445-4faa-b8fd-db7f363b458c');

-- reservation_car_sht for reservation fdd8eb8b-6655-4ac2-a664-2f7af3ddbe23
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'fdd8eb8b-6655-4ac2-a664-2f7af3ddbe23', '2025-08-15T13:10:15.26+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'fdd8eb8b-6655-4ac2-a664-2f7af3ddbe23');

-- reservation_car_sht for reservation d0838249-0ba6-4a44-b63c-6c90c43fb325
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd0838249-0ba6-4a44-b63c-6c90c43fb325', '2025-08-15T13:10:15.177+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd0838249-0ba6-4a44-b63c-6c90c43fb325');

-- reservation_car_sht for reservation 8398159b-2fbb-45c5-92a1-0385d16363c7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8398159b-2fbb-45c5-92a1-0385d16363c7', '2025-08-15T13:10:15.08+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8398159b-2fbb-45c5-92a1-0385d16363c7');

-- reservation_car_sht for reservation 42204b32-0ea8-429e-9a67-5e7ca58d979f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '42204b32-0ea8-429e-9a67-5e7ca58d979f', '2025-08-15T13:10:14.988+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '42204b32-0ea8-429e-9a67-5e7ca58d979f');

-- reservation_car_sht for reservation 2b0e3461-3e50-4115-8252-04cafc50bd2c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '2b0e3461-3e50-4115-8252-04cafc50bd2c', '2025-08-15T13:10:14.898+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '2b0e3461-3e50-4115-8252-04cafc50bd2c');

-- reservation_car_sht for reservation 49b11883-f282-4395-be21-7d9bd9cd2fc4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '49b11883-f282-4395-be21-7d9bd9cd2fc4', '2025-08-15T13:10:14.823+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '49b11883-f282-4395-be21-7d9bd9cd2fc4');

-- reservation_car_sht for reservation 16453947-d0c1-487a-9cf4-22ca8f80fe74
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '16453947-d0c1-487a-9cf4-22ca8f80fe74', '2025-08-15T13:10:14.743+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '16453947-d0c1-487a-9cf4-22ca8f80fe74');

-- reservation_car_sht for reservation e8519719-93f7-4ef1-b87d-f8afa95cf6f0
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e8519719-93f7-4ef1-b87d-f8afa95cf6f0', '2025-08-15T13:10:14.647+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e8519719-93f7-4ef1-b87d-f8afa95cf6f0');

-- reservation_car_sht for reservation 8be43960-b9b7-4618-b5fc-13de84227a11
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8be43960-b9b7-4618-b5fc-13de84227a11', '2025-08-15T13:10:14.527+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8be43960-b9b7-4618-b5fc-13de84227a11');

-- reservation_car_sht for reservation 5244a0be-0b62-4705-b24a-3f4b0b8171e0
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5244a0be-0b62-4705-b24a-3f4b0b8171e0', '2025-08-15T13:10:14.428+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5244a0be-0b62-4705-b24a-3f4b0b8171e0');

-- reservation_car_sht for reservation 97aa5e47-7a8e-4254-9ed6-a35fe971f076
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '97aa5e47-7a8e-4254-9ed6-a35fe971f076', '2025-08-15T13:10:14.302+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '97aa5e47-7a8e-4254-9ed6-a35fe971f076');

-- reservation_car_sht for reservation 50003e59-1002-48a7-b554-48573dcc721f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '50003e59-1002-48a7-b554-48573dcc721f', '2025-08-15T13:10:14.226+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '50003e59-1002-48a7-b554-48573dcc721f');

-- reservation_car_sht for reservation 64d623eb-f3af-4f32-825c-b073b4141a1a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '64d623eb-f3af-4f32-825c-b073b4141a1a', '2025-08-15T13:10:14.096+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '64d623eb-f3af-4f32-825c-b073b4141a1a');

-- reservation_car_sht for reservation 86b405c7-5ce1-438f-b581-0b8a7e121a35
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '86b405c7-5ce1-438f-b581-0b8a7e121a35', '2025-08-15T13:10:14.004+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '86b405c7-5ce1-438f-b581-0b8a7e121a35');

-- reservation_car_sht for reservation c364bbf6-a764-4735-b211-7cda0785e83f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c364bbf6-a764-4735-b211-7cda0785e83f', '2025-08-15T13:10:13.889+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c364bbf6-a764-4735-b211-7cda0785e83f');

-- reservation_car_sht for reservation aa2c93f4-c70f-4008-b6c7-a2dcd4c3f72d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'aa2c93f4-c70f-4008-b6c7-a2dcd4c3f72d', '2025-08-15T13:10:13.779+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'aa2c93f4-c70f-4008-b6c7-a2dcd4c3f72d');

-- reservation_car_sht for reservation f2bea21d-8a0b-4163-9c7e-7d313ebf9070
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f2bea21d-8a0b-4163-9c7e-7d313ebf9070', '2025-08-15T13:10:13.677+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f2bea21d-8a0b-4163-9c7e-7d313ebf9070');

-- reservation_car_sht for reservation 7fd3708f-2b8f-4f10-8a7f-a308e92fe4eb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7fd3708f-2b8f-4f10-8a7f-a308e92fe4eb', '2025-08-15T13:10:13.586+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7fd3708f-2b8f-4f10-8a7f-a308e92fe4eb');

-- reservation_car_sht for reservation 70f73c39-b1ab-43c6-9558-77b2c7fb2c55
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '70f73c39-b1ab-43c6-9558-77b2c7fb2c55', '2025-08-15T13:10:13.473+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '70f73c39-b1ab-43c6-9558-77b2c7fb2c55');

-- reservation_car_sht for reservation 3b587667-9301-4a7f-8da3-b32daaa2bb92
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3b587667-9301-4a7f-8da3-b32daaa2bb92', '2025-08-15T13:10:13.368+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3b587667-9301-4a7f-8da3-b32daaa2bb92');

-- reservation_car_sht for reservation 2edfc65d-3ac9-44fa-96f5-d26882efb328
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '2edfc65d-3ac9-44fa-96f5-d26882efb328', '2025-08-15T13:10:13.254+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '2edfc65d-3ac9-44fa-96f5-d26882efb328');

-- reservation_car_sht for reservation 39e9f773-cb76-4f82-82a9-dce315aff55c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '39e9f773-cb76-4f82-82a9-dce315aff55c', '2025-08-15T13:10:13.144+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '39e9f773-cb76-4f82-82a9-dce315aff55c');

-- reservation_car_sht for reservation 10ffeb9b-ee07-4776-9b37-96f4965be293
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '10ffeb9b-ee07-4776-9b37-96f4965be293', '2025-08-15T13:10:13.03+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '10ffeb9b-ee07-4776-9b37-96f4965be293');

-- reservation_car_sht for reservation a7321af9-6fce-4a9b-ba71-9aa1d4aeb2a4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a7321af9-6fce-4a9b-ba71-9aa1d4aeb2a4', '2025-08-15T13:10:12.948+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a7321af9-6fce-4a9b-ba71-9aa1d4aeb2a4');

-- reservation_car_sht for reservation 7b4193ef-50aa-46a5-99e6-cfcdfb9be025
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7b4193ef-50aa-46a5-99e6-cfcdfb9be025', '2025-08-15T13:10:12.856+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7b4193ef-50aa-46a5-99e6-cfcdfb9be025');

-- reservation_car_sht for reservation df66429f-4b62-4e38-ab51-05dc5cc5aae0
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'df66429f-4b62-4e38-ab51-05dc5cc5aae0', '2025-08-15T13:10:12.763+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'df66429f-4b62-4e38-ab51-05dc5cc5aae0');

-- reservation_car_sht for reservation c0863de2-4813-4d38-8701-4e9c1ce89efb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c0863de2-4813-4d38-8701-4e9c1ce89efb', '2025-08-15T13:10:12.682+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c0863de2-4813-4d38-8701-4e9c1ce89efb');

-- reservation_car_sht for reservation 32004a4f-dc2d-4099-89a9-15a63cebbfde
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '32004a4f-dc2d-4099-89a9-15a63cebbfde', '2025-08-15T13:10:12.537+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '32004a4f-dc2d-4099-89a9-15a63cebbfde');

-- reservation_car_sht for reservation 7e50e406-3638-4f73-ade1-1b6f42930bbc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7e50e406-3638-4f73-ade1-1b6f42930bbc', '2025-08-15T13:10:12.438+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7e50e406-3638-4f73-ade1-1b6f42930bbc');

-- reservation_car_sht for reservation 41163127-3449-4707-bf2b-9a7c0bc72764
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '41163127-3449-4707-bf2b-9a7c0bc72764', '2025-08-15T13:10:12.345+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '41163127-3449-4707-bf2b-9a7c0bc72764');

-- reservation_car_sht for reservation 6fd7db81-fe99-469b-8e04-47a23f52d83f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6fd7db81-fe99-469b-8e04-47a23f52d83f', '2025-08-15T13:10:12.255+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6fd7db81-fe99-469b-8e04-47a23f52d83f');

-- reservation_car_sht for reservation 5f2c39aa-12ff-403c-8a78-a2975e09ae57
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5f2c39aa-12ff-403c-8a78-a2975e09ae57', '2025-08-15T13:10:12.172+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5f2c39aa-12ff-403c-8a78-a2975e09ae57');

-- reservation_car_sht for reservation a8ba0dc8-0350-4e9f-9877-1e5f8d6ba230
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a8ba0dc8-0350-4e9f-9877-1e5f8d6ba230', '2025-08-15T13:10:12.089+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a8ba0dc8-0350-4e9f-9877-1e5f8d6ba230');

-- reservation_car_sht for reservation d61718da-af91-4e84-bd45-2f10051fa55f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd61718da-af91-4e84-bd45-2f10051fa55f', '2025-08-15T13:10:11.988+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd61718da-af91-4e84-bd45-2f10051fa55f');

-- reservation_car_sht for reservation cae00576-9fd9-48d2-b6e4-3cec0e067ef2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'cae00576-9fd9-48d2-b6e4-3cec0e067ef2', '2025-08-15T13:10:11.885+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'cae00576-9fd9-48d2-b6e4-3cec0e067ef2');

-- reservation_car_sht for reservation 69a8c495-1f39-4608-85c0-c3391f3f572c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '69a8c495-1f39-4608-85c0-c3391f3f572c', '2025-08-15T13:10:11.8+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '69a8c495-1f39-4608-85c0-c3391f3f572c');

-- reservation_car_sht for reservation d68ecaf9-5d17-4b4f-b847-e14b96c00de4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd68ecaf9-5d17-4b4f-b847-e14b96c00de4', '2025-08-15T13:10:11.707+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd68ecaf9-5d17-4b4f-b847-e14b96c00de4');

-- reservation_car_sht for reservation 7dc5cab0-2676-4722-a632-abf85aa548ee
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7dc5cab0-2676-4722-a632-abf85aa548ee', '2025-08-15T13:10:11.621+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7dc5cab0-2676-4722-a632-abf85aa548ee');

-- reservation_car_sht for reservation 76382282-a7d6-437f-9447-774334d546ba
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '76382282-a7d6-437f-9447-774334d546ba', '2025-08-15T13:10:11.536+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '76382282-a7d6-437f-9447-774334d546ba');

-- reservation_car_sht for reservation c7010031-0723-43a3-b403-e36dc212b6a1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c7010031-0723-43a3-b403-e36dc212b6a1', '2025-08-15T13:10:11.453+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c7010031-0723-43a3-b403-e36dc212b6a1');

-- reservation_car_sht for reservation fc6e1b54-5589-4c31-9597-bfc0d40920dc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'fc6e1b54-5589-4c31-9597-bfc0d40920dc', '2025-08-15T13:10:11.375+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'fc6e1b54-5589-4c31-9597-bfc0d40920dc');

-- reservation_car_sht for reservation 51d9cce1-ade4-4cb0-b820-df67b76925a3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '51d9cce1-ade4-4cb0-b820-df67b76925a3', '2025-08-15T13:10:11.285+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '51d9cce1-ade4-4cb0-b820-df67b76925a3');

-- reservation_car_sht for reservation b002a9d3-edf7-422d-b858-658a958ba964
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b002a9d3-edf7-422d-b858-658a958ba964', '2025-08-15T13:10:11.193+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b002a9d3-edf7-422d-b858-658a958ba964');

-- reservation_car_sht for reservation be98d06a-f486-42a7-93fb-2defd2d2a6cc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'be98d06a-f486-42a7-93fb-2defd2d2a6cc', '2025-08-15T13:10:11.11+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'be98d06a-f486-42a7-93fb-2defd2d2a6cc');

-- reservation_car_sht for reservation 597d5dfe-ff26-4611-9542-8d133db76cfe
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '597d5dfe-ff26-4611-9542-8d133db76cfe', '2025-08-15T13:10:11.024+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '597d5dfe-ff26-4611-9542-8d133db76cfe');

-- reservation_car_sht for reservation 0bc7e68d-b26e-4542-8a24-f91d3e76de0e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0bc7e68d-b26e-4542-8a24-f91d3e76de0e', '2025-08-15T13:10:10.936+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0bc7e68d-b26e-4542-8a24-f91d3e76de0e');

-- reservation_car_sht for reservation c8022151-45d1-43c6-bc19-742132562df5
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c8022151-45d1-43c6-bc19-742132562df5', '2025-08-15T13:10:10.834+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c8022151-45d1-43c6-bc19-742132562df5');

-- reservation_car_sht for reservation a2053923-2dc9-4f23-ad0d-f94aecd02839
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a2053923-2dc9-4f23-ad0d-f94aecd02839', '2025-08-15T13:10:10.739+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a2053923-2dc9-4f23-ad0d-f94aecd02839');

COMMIT;
