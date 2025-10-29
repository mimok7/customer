-- Auto-generated SQL to insert minimal missing service-detail rows
-- Review carefully before running. This script uses re_created_at as a fallback datetime where explicit service dates are absent.
-- Run in a transaction and/or on a replica for verification.

BEGIN;

-- reservation_car_sht for reservation ba434bea-3e33-4d88-a0ff-4bb001a9b9c6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ba434bea-3e33-4d88-a0ff-4bb001a9b9c6', '2025-08-15T13:10:10.656+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ba434bea-3e33-4d88-a0ff-4bb001a9b9c6');

-- reservation_car_sht for reservation 272d5741-5369-44f8-b28c-6db7068a5de8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '272d5741-5369-44f8-b28c-6db7068a5de8', '2025-08-15T13:10:10.567+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '272d5741-5369-44f8-b28c-6db7068a5de8');

-- reservation_car_sht for reservation 844cda7d-6488-4be6-9a0e-d24643833e83
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '844cda7d-6488-4be6-9a0e-d24643833e83', '2025-08-15T13:10:10.489+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '844cda7d-6488-4be6-9a0e-d24643833e83');

-- reservation_car_sht for reservation 4fe0af7a-fc7b-4a40-8d79-bcdcac2361fa
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4fe0af7a-fc7b-4a40-8d79-bcdcac2361fa', '2025-08-15T13:10:10.408+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4fe0af7a-fc7b-4a40-8d79-bcdcac2361fa');

-- reservation_car_sht for reservation a3ef1f5a-da1c-4306-b682-a5b1e75b0eb2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a3ef1f5a-da1c-4306-b682-a5b1e75b0eb2', '2025-08-15T13:10:10.312+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a3ef1f5a-da1c-4306-b682-a5b1e75b0eb2');

-- reservation_car_sht for reservation b463c434-eee7-4fab-9fe2-f834e3e65657
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b463c434-eee7-4fab-9fe2-f834e3e65657', '2025-08-15T13:10:10.227+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b463c434-eee7-4fab-9fe2-f834e3e65657');

-- reservation_car_sht for reservation 4c9cb6a4-baf4-4680-8b0e-7da4b08ae4fa
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4c9cb6a4-baf4-4680-8b0e-7da4b08ae4fa', '2025-08-15T13:10:10.14+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4c9cb6a4-baf4-4680-8b0e-7da4b08ae4fa');

-- reservation_car_sht for reservation d831d585-a296-4597-a841-459da6f2ab0e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd831d585-a296-4597-a841-459da6f2ab0e', '2025-08-15T13:10:10.055+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd831d585-a296-4597-a841-459da6f2ab0e');

-- reservation_car_sht for reservation 326a1770-75b1-4422-9855-a1539ecc6905
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '326a1770-75b1-4422-9855-a1539ecc6905', '2025-08-15T13:10:09.954+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '326a1770-75b1-4422-9855-a1539ecc6905');

-- reservation_car_sht for reservation 10517ca3-333c-4548-9272-8982abc1fca2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '10517ca3-333c-4548-9272-8982abc1fca2', '2025-08-15T13:10:09.858+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '10517ca3-333c-4548-9272-8982abc1fca2');

-- reservation_car_sht for reservation b9e33e49-f56c-4662-901d-d6084621a42f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b9e33e49-f56c-4662-901d-d6084621a42f', '2025-08-15T13:10:09.771+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b9e33e49-f56c-4662-901d-d6084621a42f');

-- reservation_car_sht for reservation e7936425-06b3-43a9-a03f-3cda28529e43
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e7936425-06b3-43a9-a03f-3cda28529e43', '2025-08-15T13:10:09.685+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e7936425-06b3-43a9-a03f-3cda28529e43');

-- reservation_car_sht for reservation a1bb8a8a-8f47-4ab6-ad49-5a8d383ec3e6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a1bb8a8a-8f47-4ab6-ad49-5a8d383ec3e6', '2025-08-15T13:10:09.554+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a1bb8a8a-8f47-4ab6-ad49-5a8d383ec3e6');

-- reservation_car_sht for reservation 60c63fd4-3e08-49e6-9e48-94021ba0a58b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '60c63fd4-3e08-49e6-9e48-94021ba0a58b', '2025-08-15T13:10:09.432+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '60c63fd4-3e08-49e6-9e48-94021ba0a58b');

-- reservation_car_sht for reservation 523580f2-2b8c-4519-8068-ef9bcf7388b1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '523580f2-2b8c-4519-8068-ef9bcf7388b1', '2025-08-15T13:10:09.295+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '523580f2-2b8c-4519-8068-ef9bcf7388b1');

-- reservation_car_sht for reservation 7366ffea-896a-48d5-97ce-c71002fea874
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7366ffea-896a-48d5-97ce-c71002fea874', '2025-08-15T13:10:09.213+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7366ffea-896a-48d5-97ce-c71002fea874');

-- reservation_car_sht for reservation 54b98662-3c75-4ead-9d09-5f0db469af14
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '54b98662-3c75-4ead-9d09-5f0db469af14', '2025-08-15T13:10:09.11+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '54b98662-3c75-4ead-9d09-5f0db469af14');

-- reservation_car_sht for reservation 8509a8b6-1243-4782-9f5f-5b5bb54915ca
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8509a8b6-1243-4782-9f5f-5b5bb54915ca', '2025-08-15T13:10:09.004+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8509a8b6-1243-4782-9f5f-5b5bb54915ca');

-- reservation_car_sht for reservation 28d6d0b9-09c5-4a2b-8372-0cdbb3da4b3c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '28d6d0b9-09c5-4a2b-8372-0cdbb3da4b3c', '2025-08-15T13:10:08.926+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '28d6d0b9-09c5-4a2b-8372-0cdbb3da4b3c');

-- reservation_car_sht for reservation 7770254d-73a7-4a2c-b01f-baffe2780efe
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7770254d-73a7-4a2c-b01f-baffe2780efe', '2025-08-15T13:10:08.85+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7770254d-73a7-4a2c-b01f-baffe2780efe');

-- reservation_car_sht for reservation a2bf86af-a4c6-4643-9ea3-c856bf45cdbd
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a2bf86af-a4c6-4643-9ea3-c856bf45cdbd', '2025-08-15T13:10:08.761+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a2bf86af-a4c6-4643-9ea3-c856bf45cdbd');

-- reservation_car_sht for reservation 7b52295e-ee14-492e-a229-8603f1401528
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7b52295e-ee14-492e-a229-8603f1401528', '2025-08-15T13:10:08.682+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7b52295e-ee14-492e-a229-8603f1401528');

-- reservation_car_sht for reservation d8a66ce9-51ca-4338-ba3b-5d5c1c2dc806
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd8a66ce9-51ca-4338-ba3b-5d5c1c2dc806', '2025-08-15T13:10:08.6+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd8a66ce9-51ca-4338-ba3b-5d5c1c2dc806');

-- reservation_car_sht for reservation 44bb31c1-2982-4be0-bcc8-80d9881f0e28
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '44bb31c1-2982-4be0-bcc8-80d9881f0e28', '2025-08-15T13:10:08.518+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '44bb31c1-2982-4be0-bcc8-80d9881f0e28');

-- reservation_car_sht for reservation d9ac2633-eac0-473e-abe2-472e5a2c913f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd9ac2633-eac0-473e-abe2-472e5a2c913f', '2025-08-15T13:10:08.437+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd9ac2633-eac0-473e-abe2-472e5a2c913f');

-- reservation_car_sht for reservation 6a54d602-90be-4fec-bd21-12018026c6dd
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6a54d602-90be-4fec-bd21-12018026c6dd', '2025-08-15T13:10:08.344+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6a54d602-90be-4fec-bd21-12018026c6dd');

-- reservation_car_sht for reservation ebf982ec-eca8-4286-aaa4-17669534ccbb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ebf982ec-eca8-4286-aaa4-17669534ccbb', '2025-08-15T13:10:08.218+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ebf982ec-eca8-4286-aaa4-17669534ccbb');

-- reservation_car_sht for reservation 6124ab97-1d1a-4844-ad7c-dced2107783e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6124ab97-1d1a-4844-ad7c-dced2107783e', '2025-08-15T13:10:08.114+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6124ab97-1d1a-4844-ad7c-dced2107783e');

-- reservation_car_sht for reservation 514904e3-8208-4b73-9126-9134fee7ab60
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '514904e3-8208-4b73-9126-9134fee7ab60', '2025-08-15T13:10:08.025+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '514904e3-8208-4b73-9126-9134fee7ab60');

-- reservation_car_sht for reservation 0c2d64ce-b945-4d1d-a776-401a7df7aa6a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0c2d64ce-b945-4d1d-a776-401a7df7aa6a', '2025-08-15T13:10:07.952+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0c2d64ce-b945-4d1d-a776-401a7df7aa6a');

-- reservation_car_sht for reservation e2157042-9afd-4b3a-a40a-489f07d331bb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e2157042-9afd-4b3a-a40a-489f07d331bb', '2025-08-15T13:10:07.875+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e2157042-9afd-4b3a-a40a-489f07d331bb');

-- reservation_car_sht for reservation fc011888-1dc3-4d6e-8f42-08f5f351251a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'fc011888-1dc3-4d6e-8f42-08f5f351251a', '2025-08-15T13:10:07.784+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'fc011888-1dc3-4d6e-8f42-08f5f351251a');

-- reservation_car_sht for reservation 819c6aba-fb1d-4a40-965a-2c5ffe35904b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '819c6aba-fb1d-4a40-965a-2c5ffe35904b', '2025-08-15T13:10:07.709+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '819c6aba-fb1d-4a40-965a-2c5ffe35904b');

-- reservation_car_sht for reservation a2551c38-8e55-478e-b254-ba0366be3240
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a2551c38-8e55-478e-b254-ba0366be3240', '2025-08-15T13:10:07.624+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a2551c38-8e55-478e-b254-ba0366be3240');

-- reservation_car_sht for reservation 79b9959a-b6d6-4a54-88cb-02d333c3ec42
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '79b9959a-b6d6-4a54-88cb-02d333c3ec42', '2025-08-15T13:10:07.535+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '79b9959a-b6d6-4a54-88cb-02d333c3ec42');

-- reservation_car_sht for reservation db5fc207-faa3-45ad-bc7f-dd3119a979c7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'db5fc207-faa3-45ad-bc7f-dd3119a979c7', '2025-08-15T13:10:07.436+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'db5fc207-faa3-45ad-bc7f-dd3119a979c7');

-- reservation_car_sht for reservation 8fcc2135-c8a3-4088-82b1-9c8b9e05e48e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8fcc2135-c8a3-4088-82b1-9c8b9e05e48e', '2025-08-15T13:10:07.348+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8fcc2135-c8a3-4088-82b1-9c8b9e05e48e');

-- reservation_car_sht for reservation 1e0a9d23-3a31-46f8-af58-40e22bd14d6f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1e0a9d23-3a31-46f8-af58-40e22bd14d6f', '2025-08-15T13:10:07.252+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1e0a9d23-3a31-46f8-af58-40e22bd14d6f');

-- reservation_car_sht for reservation 836f9632-c40f-42c5-93d2-3c97a02f8c9c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '836f9632-c40f-42c5-93d2-3c97a02f8c9c', '2025-08-15T13:10:07.176+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '836f9632-c40f-42c5-93d2-3c97a02f8c9c');

-- reservation_car_sht for reservation 8ea43df8-f418-425c-ad76-82f1153a858a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8ea43df8-f418-425c-ad76-82f1153a858a', '2025-08-15T13:10:07.088+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8ea43df8-f418-425c-ad76-82f1153a858a');

-- reservation_car_sht for reservation a035f460-6ad1-4d3d-b03d-dba1fedcc9d2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a035f460-6ad1-4d3d-b03d-dba1fedcc9d2', '2025-08-15T13:10:07.014+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a035f460-6ad1-4d3d-b03d-dba1fedcc9d2');

-- reservation_car_sht for reservation 7ea889bb-33b7-495a-b174-0a249fee6178
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7ea889bb-33b7-495a-b174-0a249fee6178', '2025-08-15T13:10:06.92+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7ea889bb-33b7-495a-b174-0a249fee6178');

-- reservation_car_sht for reservation e3a07544-8070-4318-aa9d-eda76668c81b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e3a07544-8070-4318-aa9d-eda76668c81b', '2025-08-15T13:10:06.824+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e3a07544-8070-4318-aa9d-eda76668c81b');

-- reservation_car_sht for reservation 351e9806-3b4f-46d6-98c8-d0d084a779af
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '351e9806-3b4f-46d6-98c8-d0d084a779af', '2025-08-15T13:10:06.738+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '351e9806-3b4f-46d6-98c8-d0d084a779af');

-- reservation_car_sht for reservation a844dbc2-1f09-4fb4-83b2-8db840d46396
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a844dbc2-1f09-4fb4-83b2-8db840d46396', '2025-08-15T13:10:06.642+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a844dbc2-1f09-4fb4-83b2-8db840d46396');

-- reservation_car_sht for reservation 58edf22c-838d-4ea6-aa4d-c477b97bc758
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '58edf22c-838d-4ea6-aa4d-c477b97bc758', '2025-08-15T13:10:06.557+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '58edf22c-838d-4ea6-aa4d-c477b97bc758');

-- reservation_car_sht for reservation edc33dc2-e2cf-499c-8d0a-ea96b1619c50
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'edc33dc2-e2cf-499c-8d0a-ea96b1619c50', '2025-08-15T13:10:06.455+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'edc33dc2-e2cf-499c-8d0a-ea96b1619c50');

-- reservation_car_sht for reservation 6ad24a9b-bd19-4c2a-97cb-8d9d350ffa57
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6ad24a9b-bd19-4c2a-97cb-8d9d350ffa57', '2025-08-15T13:10:06.374+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6ad24a9b-bd19-4c2a-97cb-8d9d350ffa57');

-- reservation_car_sht for reservation f37eabe4-ad71-47a0-91df-b14d2c695ae8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f37eabe4-ad71-47a0-91df-b14d2c695ae8', '2025-08-15T13:10:06.302+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f37eabe4-ad71-47a0-91df-b14d2c695ae8');

-- reservation_car_sht for reservation 562596e9-30f5-4532-9a3a-bf9de28734cc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '562596e9-30f5-4532-9a3a-bf9de28734cc', '2025-08-15T13:10:06.21+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '562596e9-30f5-4532-9a3a-bf9de28734cc');

-- reservation_car_sht for reservation ce552930-3412-4503-846d-7f127870030e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ce552930-3412-4503-846d-7f127870030e', '2025-08-15T13:10:06.097+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ce552930-3412-4503-846d-7f127870030e');

-- reservation_car_sht for reservation d5df2bc3-e419-4495-baca-24012763c58a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd5df2bc3-e419-4495-baca-24012763c58a', '2025-08-15T13:10:06+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd5df2bc3-e419-4495-baca-24012763c58a');

-- reservation_car_sht for reservation 2a00b1c0-e958-4975-b9cb-849b932a935c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '2a00b1c0-e958-4975-b9cb-849b932a935c', '2025-08-15T13:10:05.899+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '2a00b1c0-e958-4975-b9cb-849b932a935c');

-- reservation_car_sht for reservation 2f0a16ce-c066-48d2-bdd8-210824411967
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '2f0a16ce-c066-48d2-bdd8-210824411967', '2025-08-15T13:10:05.816+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '2f0a16ce-c066-48d2-bdd8-210824411967');

-- reservation_car_sht for reservation 4b562d61-9916-4ec6-bb17-62f48e304cb7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4b562d61-9916-4ec6-bb17-62f48e304cb7', '2025-08-15T13:10:05.725+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4b562d61-9916-4ec6-bb17-62f48e304cb7');

-- reservation_car_sht for reservation ac078221-f887-4488-9c85-428f0ea4785b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ac078221-f887-4488-9c85-428f0ea4785b', '2025-08-15T13:10:05.648+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ac078221-f887-4488-9c85-428f0ea4785b');

-- reservation_car_sht for reservation cc4ce840-0856-49ee-8d18-96dbd4d47436
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'cc4ce840-0856-49ee-8d18-96dbd4d47436', '2025-08-15T13:10:05.561+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'cc4ce840-0856-49ee-8d18-96dbd4d47436');

-- reservation_car_sht for reservation 269999af-4eba-4c02-a451-0974269ced42
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '269999af-4eba-4c02-a451-0974269ced42', '2025-08-15T13:10:05.454+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '269999af-4eba-4c02-a451-0974269ced42');

-- reservation_car_sht for reservation 0b85e929-80be-4ade-83af-92313297c7e3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0b85e929-80be-4ade-83af-92313297c7e3', '2025-08-15T13:10:05.362+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0b85e929-80be-4ade-83af-92313297c7e3');

-- reservation_car_sht for reservation cd5a563d-ed00-4d81-8292-abcf9f684677
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'cd5a563d-ed00-4d81-8292-abcf9f684677', '2025-08-15T13:10:05.271+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'cd5a563d-ed00-4d81-8292-abcf9f684677');

-- reservation_car_sht for reservation 254d725e-85eb-42a5-a37d-6e82f6b37f3e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '254d725e-85eb-42a5-a37d-6e82f6b37f3e', '2025-08-15T13:10:05.196+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '254d725e-85eb-42a5-a37d-6e82f6b37f3e');

-- reservation_car_sht for reservation 0cc5ac66-6020-417d-81a2-11fcb5aa12c7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0cc5ac66-6020-417d-81a2-11fcb5aa12c7', '2025-08-15T13:10:05.096+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0cc5ac66-6020-417d-81a2-11fcb5aa12c7');

-- reservation_car_sht for reservation dae8505b-855d-4a9f-8af0-e88eb859024a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'dae8505b-855d-4a9f-8af0-e88eb859024a', '2025-08-15T13:10:05.019+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'dae8505b-855d-4a9f-8af0-e88eb859024a');

-- reservation_car_sht for reservation 7f96c186-c954-49b9-a984-e2c950401c40
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7f96c186-c954-49b9-a984-e2c950401c40', '2025-08-15T13:10:04.931+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7f96c186-c954-49b9-a984-e2c950401c40');

-- reservation_car_sht for reservation 15d95807-9b27-407e-92a3-04da930e122c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '15d95807-9b27-407e-92a3-04da930e122c', '2025-08-15T13:10:04.854+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '15d95807-9b27-407e-92a3-04da930e122c');

-- reservation_car_sht for reservation 56a78871-af51-458e-8f2d-321608d82837
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '56a78871-af51-458e-8f2d-321608d82837', '2025-08-15T13:10:04.762+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '56a78871-af51-458e-8f2d-321608d82837');

-- reservation_car_sht for reservation 5b13f414-389e-455a-9d92-cdfb79918c80
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5b13f414-389e-455a-9d92-cdfb79918c80', '2025-08-15T13:10:04.667+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5b13f414-389e-455a-9d92-cdfb79918c80');

-- reservation_car_sht for reservation d13a29fd-5092-49e9-8bfc-d56a05680c62
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd13a29fd-5092-49e9-8bfc-d56a05680c62', '2025-08-15T13:10:04.594+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd13a29fd-5092-49e9-8bfc-d56a05680c62');

-- reservation_car_sht for reservation cf35feda-33d2-4aef-9de0-8a5024a706e8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'cf35feda-33d2-4aef-9de0-8a5024a706e8', '2025-08-15T13:10:04.523+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'cf35feda-33d2-4aef-9de0-8a5024a706e8');

-- reservation_car_sht for reservation bb792cb3-652e-4037-b8c8-34eca3b080b6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'bb792cb3-652e-4037-b8c8-34eca3b080b6', '2025-08-15T13:10:04.435+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'bb792cb3-652e-4037-b8c8-34eca3b080b6');

-- reservation_car_sht for reservation 3e960da8-288d-487f-aad9-fb189d452a7a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3e960da8-288d-487f-aad9-fb189d452a7a', '2025-08-15T13:10:04.306+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3e960da8-288d-487f-aad9-fb189d452a7a');

-- reservation_car_sht for reservation 888ad22a-157d-4154-86ae-3f06313563a7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '888ad22a-157d-4154-86ae-3f06313563a7', '2025-08-15T13:10:04.212+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '888ad22a-157d-4154-86ae-3f06313563a7');

-- reservation_car_sht for reservation a4aaf2be-3bba-4ad7-a54b-3f7ec7f5c2e1
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a4aaf2be-3bba-4ad7-a54b-3f7ec7f5c2e1', '2025-08-15T13:10:04.128+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a4aaf2be-3bba-4ad7-a54b-3f7ec7f5c2e1');

-- reservation_car_sht for reservation 9c5f8924-8865-48e1-ad3a-b18f49af99c2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9c5f8924-8865-48e1-ad3a-b18f49af99c2', '2025-08-15T13:10:04.03+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9c5f8924-8865-48e1-ad3a-b18f49af99c2');

-- reservation_car_sht for reservation 9706231b-732f-4ca8-b27a-247ad8fda3b0
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9706231b-732f-4ca8-b27a-247ad8fda3b0', '2025-08-15T13:10:03.939+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9706231b-732f-4ca8-b27a-247ad8fda3b0');

-- reservation_car_sht for reservation 3f50f201-517b-454a-a7c8-ef0e2c2e736b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3f50f201-517b-454a-a7c8-ef0e2c2e736b', '2025-08-15T13:10:03.858+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3f50f201-517b-454a-a7c8-ef0e2c2e736b');

-- reservation_car_sht for reservation 9370337d-77e9-459c-a35d-ed68cbfe99d3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9370337d-77e9-459c-a35d-ed68cbfe99d3', '2025-08-15T13:10:03.756+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9370337d-77e9-459c-a35d-ed68cbfe99d3');

-- reservation_car_sht for reservation 50d184e0-5044-4685-8411-f00df699c362
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '50d184e0-5044-4685-8411-f00df699c362', '2025-08-15T13:10:03.665+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '50d184e0-5044-4685-8411-f00df699c362');

-- reservation_car_sht for reservation 22dea120-ad3b-4108-abfb-276d38a990db
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '22dea120-ad3b-4108-abfb-276d38a990db', '2025-08-15T13:10:03.581+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '22dea120-ad3b-4108-abfb-276d38a990db');

-- reservation_car_sht for reservation 5479f456-6f01-4b96-9179-164ce3a0e842
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5479f456-6f01-4b96-9179-164ce3a0e842', '2025-08-15T13:10:03.497+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5479f456-6f01-4b96-9179-164ce3a0e842');

-- reservation_car_sht for reservation 389cca4c-fd25-48e2-829d-47a7d9ce6c41
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '389cca4c-fd25-48e2-829d-47a7d9ce6c41', '2025-08-15T13:10:03.415+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '389cca4c-fd25-48e2-829d-47a7d9ce6c41');

-- reservation_car_sht for reservation dc968f1e-9d56-4023-9360-71b55008e2b3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'dc968f1e-9d56-4023-9360-71b55008e2b3', '2025-08-15T13:10:03.338+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'dc968f1e-9d56-4023-9360-71b55008e2b3');

-- reservation_car_sht for reservation 12a35b73-31ad-4468-a3cd-264aa5e875a3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '12a35b73-31ad-4468-a3cd-264aa5e875a3', '2025-08-15T13:10:03.256+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '12a35b73-31ad-4468-a3cd-264aa5e875a3');

-- reservation_car_sht for reservation 5c16fdc3-e79f-4632-b621-9baec3f27e9d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5c16fdc3-e79f-4632-b621-9baec3f27e9d', '2025-08-15T13:10:03.16+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5c16fdc3-e79f-4632-b621-9baec3f27e9d');

-- reservation_car_sht for reservation 5837ff9c-321d-46bb-9f83-a47b2b3802e5
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5837ff9c-321d-46bb-9f83-a47b2b3802e5', '2025-08-15T13:10:03.063+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5837ff9c-321d-46bb-9f83-a47b2b3802e5');

-- reservation_car_sht for reservation 45170aa8-9687-4158-ac98-ea9beca63e33
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '45170aa8-9687-4158-ac98-ea9beca63e33', '2025-08-15T13:10:02.979+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '45170aa8-9687-4158-ac98-ea9beca63e33');

-- reservation_car_sht for reservation c7ab9f98-88d9-4263-960b-32ab7d3c5274
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c7ab9f98-88d9-4263-960b-32ab7d3c5274', '2025-08-15T13:10:02.888+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c7ab9f98-88d9-4263-960b-32ab7d3c5274');

-- reservation_car_sht for reservation a0c691f6-ee48-4ab6-8cc8-0fa83f2391b3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a0c691f6-ee48-4ab6-8cc8-0fa83f2391b3', '2025-08-15T13:10:02.802+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a0c691f6-ee48-4ab6-8cc8-0fa83f2391b3');

-- reservation_car_sht for reservation 02adc3b5-a19f-4955-bb7b-e69b073a30ad
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '02adc3b5-a19f-4955-bb7b-e69b073a30ad', '2025-08-15T13:10:02.722+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '02adc3b5-a19f-4955-bb7b-e69b073a30ad');

-- reservation_car_sht for reservation e933bdad-58c1-411a-8568-51dfd9d2c1ba
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e933bdad-58c1-411a-8568-51dfd9d2c1ba', '2025-08-15T13:10:02.633+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e933bdad-58c1-411a-8568-51dfd9d2c1ba');

-- reservation_car_sht for reservation c80d21e3-e2df-4e22-b4dc-4a76c87773f9
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c80d21e3-e2df-4e22-b4dc-4a76c87773f9', '2025-08-15T13:10:02.538+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c80d21e3-e2df-4e22-b4dc-4a76c87773f9');

-- reservation_car_sht for reservation 8bcb0ec1-7a14-4d64-926c-898effb7b3bc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8bcb0ec1-7a14-4d64-926c-898effb7b3bc', '2025-08-15T13:10:02.451+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8bcb0ec1-7a14-4d64-926c-898effb7b3bc');

-- reservation_car_sht for reservation d66aaf19-8b63-430a-94e7-2ff14144fab2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd66aaf19-8b63-430a-94e7-2ff14144fab2', '2025-08-15T13:10:02.354+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd66aaf19-8b63-430a-94e7-2ff14144fab2');

-- reservation_car_sht for reservation ca5659c3-fc44-465f-b0ec-e72fdbdeb24f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ca5659c3-fc44-465f-b0ec-e72fdbdeb24f', '2025-08-15T13:10:02.28+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ca5659c3-fc44-465f-b0ec-e72fdbdeb24f');

-- reservation_car_sht for reservation a6368078-590b-434e-bbe9-b309bc35874d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a6368078-590b-434e-bbe9-b309bc35874d', '2025-08-15T13:10:02.198+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a6368078-590b-434e-bbe9-b309bc35874d');

-- reservation_car_sht for reservation 72733144-7c13-42e5-a7e1-7730cc02b435
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '72733144-7c13-42e5-a7e1-7730cc02b435', '2025-08-15T13:10:02.108+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '72733144-7c13-42e5-a7e1-7730cc02b435');

-- reservation_car_sht for reservation 56d6251b-218b-4eed-85b7-7f613d2c2201
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '56d6251b-218b-4eed-85b7-7f613d2c2201', '2025-08-15T13:10:02.023+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '56d6251b-218b-4eed-85b7-7f613d2c2201');

-- reservation_car_sht for reservation f291c1d8-3ee0-4bb6-97cd-a59344ce047f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f291c1d8-3ee0-4bb6-97cd-a59344ce047f', '2025-08-15T13:10:01.937+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f291c1d8-3ee0-4bb6-97cd-a59344ce047f');

-- reservation_car_sht for reservation 330ac3d1-b1ef-4453-ad96-494db79dd2e9
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '330ac3d1-b1ef-4453-ad96-494db79dd2e9', '2025-08-15T13:10:01.855+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '330ac3d1-b1ef-4453-ad96-494db79dd2e9');

-- reservation_car_sht for reservation f4653df7-43f6-4d02-8389-2d2aa296f582
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f4653df7-43f6-4d02-8389-2d2aa296f582', '2025-08-15T13:10:01.781+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f4653df7-43f6-4d02-8389-2d2aa296f582');

COMMIT;
