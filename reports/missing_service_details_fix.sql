-- Auto-generated SQL to insert minimal missing service-detail rows
-- Review carefully before running. This script uses re_created_at as a fallback datetime where explicit service dates are absent.
-- Run in a transaction and/or on a replica for verification.

BEGIN;

-- reservation_airport for reservation b9ae7b1d-c314-4037-91ef-16140a68de11
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'b9ae7b1d-c314-4037-91ef-16140a68de11', '2025-08-17T03:33:59.523056+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'b9ae7b1d-c314-4037-91ef-16140a68de11');

-- reservation_airport for reservation 087f9a4d-b8b1-4ac7-b576-b7d628a197ce
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '087f9a4d-b8b1-4ac7-b576-b7d628a197ce', '2025-08-17T02:30:58.131+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '087f9a4d-b8b1-4ac7-b576-b7d628a197ce');

-- reservation_airport for reservation 3c12400f-2767-44b9-9fdc-6a652c2c8dd5
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '3c12400f-2767-44b9-9fdc-6a652c2c8dd5', '2025-08-17T02:30:58.015+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '3c12400f-2767-44b9-9fdc-6a652c2c8dd5');

-- reservation_airport for reservation 27dbca75-4379-4882-8070-8d81aff42115
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '27dbca75-4379-4882-8070-8d81aff42115', '2025-08-17T02:30:57.921+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '27dbca75-4379-4882-8070-8d81aff42115');

-- reservation_airport for reservation cfc97911-03ca-4ee3-9019-d9b28f54bb56
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'cfc97911-03ca-4ee3-9019-d9b28f54bb56', '2025-08-17T02:30:57.8+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'cfc97911-03ca-4ee3-9019-d9b28f54bb56');

-- reservation_airport for reservation e734a97f-e454-421f-bf50-8160a2c9cfcf
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'e734a97f-e454-421f-bf50-8160a2c9cfcf', '2025-08-17T02:30:57.709+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'e734a97f-e454-421f-bf50-8160a2c9cfcf');

-- reservation_airport for reservation cc6ebca0-9367-40d9-939c-e18f67dc304c
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'cc6ebca0-9367-40d9-939c-e18f67dc304c', '2025-08-17T02:30:57.625+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'cc6ebca0-9367-40d9-939c-e18f67dc304c');

-- reservation_airport for reservation af9c902f-7d98-49d5-a8c2-041244661c7f
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'af9c902f-7d98-49d5-a8c2-041244661c7f', '2025-08-17T02:30:57.494+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'af9c902f-7d98-49d5-a8c2-041244661c7f');

-- reservation_airport for reservation 00ca8176-e0c6-4928-90ef-a97ca2ea0b73
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '00ca8176-e0c6-4928-90ef-a97ca2ea0b73', '2025-08-17T02:30:57.371+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '00ca8176-e0c6-4928-90ef-a97ca2ea0b73');

-- reservation_airport for reservation 87e7bda8-6f68-4983-8767-6f081f5e4b43
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '87e7bda8-6f68-4983-8767-6f081f5e4b43', '2025-08-17T02:30:57.26+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '87e7bda8-6f68-4983-8767-6f081f5e4b43');

-- reservation_airport for reservation 8d34eb2c-f301-4031-a71c-1213c66495c9
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '8d34eb2c-f301-4031-a71c-1213c66495c9', '2025-08-17T02:30:57.178+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '8d34eb2c-f301-4031-a71c-1213c66495c9');

-- reservation_airport for reservation 648af6e2-3f1b-45a0-aba7-43c18898fd8c
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '648af6e2-3f1b-45a0-aba7-43c18898fd8c', '2025-08-17T02:30:57.051+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '648af6e2-3f1b-45a0-aba7-43c18898fd8c');

-- reservation_airport for reservation aac4c846-5903-45ef-bf0e-758c44a86ed6
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'aac4c846-5903-45ef-bf0e-758c44a86ed6', '2025-08-17T02:30:56.946+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'aac4c846-5903-45ef-bf0e-758c44a86ed6');

-- reservation_airport for reservation afaf725a-0c0d-4737-9aa9-169db0d05de9
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'afaf725a-0c0d-4737-9aa9-169db0d05de9', '2025-08-17T02:30:56.867+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'afaf725a-0c0d-4737-9aa9-169db0d05de9');

-- reservation_airport for reservation a3b8bca5-de59-47e4-bbaf-bb57306a0fb1
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'a3b8bca5-de59-47e4-bbaf-bb57306a0fb1', '2025-08-17T02:30:56.785+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'a3b8bca5-de59-47e4-bbaf-bb57306a0fb1');

-- reservation_airport for reservation baa6f05a-2bc0-4e77-9166-e031904617a8
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'baa6f05a-2bc0-4e77-9166-e031904617a8', '2025-08-17T02:30:56.365+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'baa6f05a-2bc0-4e77-9166-e031904617a8');

-- reservation_airport for reservation b9aa3b46-b625-4c6c-b84c-a287d30c067c
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'b9aa3b46-b625-4c6c-b84c-a287d30c067c', '2025-08-17T02:30:56.038+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'b9aa3b46-b625-4c6c-b84c-a287d30c067c');

-- reservation_airport for reservation ac5f484a-8067-4f39-bad2-940ef3c21737
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'ac5f484a-8067-4f39-bad2-940ef3c21737', '2025-08-17T02:30:55.801+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'ac5f484a-8067-4f39-bad2-940ef3c21737');

-- reservation_airport for reservation 25ba3473-66aa-4e27-ae01-34c3d47ffd76
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '25ba3473-66aa-4e27-ae01-34c3d47ffd76', '2025-08-17T02:30:52.908+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '25ba3473-66aa-4e27-ae01-34c3d47ffd76');

-- reservation_airport for reservation a2cc3c54-3b47-44b9-af56-aa56998cc33c
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT 'a2cc3c54-3b47-44b9-af56-aa56998cc33c', '2025-08-17T02:30:52.777+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = 'a2cc3c54-3b47-44b9-af56-aa56998cc33c');

-- reservation_airport for reservation 86b293d4-4b18-458d-8e51-a0f03c19bec6
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '86b293d4-4b18-458d-8e51-a0f03c19bec6', '2025-08-17T02:30:52.651+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '86b293d4-4b18-458d-8e51-a0f03c19bec6');

-- reservation_airport for reservation 7af8bc41-5232-4d79-b706-2c22187b07ab
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '7af8bc41-5232-4d79-b706-2c22187b07ab', '2025-08-17T02:30:52.41+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '7af8bc41-5232-4d79-b706-2c22187b07ab');

-- reservation_airport for reservation 6ff4aa8d-1e5e-40ba-b920-2dec1f0f0ef1
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '6ff4aa8d-1e5e-40ba-b920-2dec1f0f0ef1', '2025-08-17T02:30:52.295+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '6ff4aa8d-1e5e-40ba-b920-2dec1f0f0ef1');

-- reservation_airport for reservation 6b9e5f26-ac88-4f06-a72d-9e8fab418e4d
INSERT INTO reservation_airport (reservation_id, ra_datetime, airport_price_code)
SELECT '6b9e5f26-ac88-4f06-a72d-9e8fab418e4d', '2025-08-17T02:30:50.611+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_airport WHERE reservation_id = '6b9e5f26-ac88-4f06-a72d-9e8fab418e4d');

-- reservation_car_sht for reservation 5b2c8438-aea6-4c77-a612-92ea4a5effc2
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5b2c8438-aea6-4c77-a612-92ea4a5effc2', '2025-08-15T13:10:28.148+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5b2c8438-aea6-4c77-a612-92ea4a5effc2');

-- reservation_car_sht for reservation e7eb545c-bb4e-419e-ae2f-bba0332472b5
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e7eb545c-bb4e-419e-ae2f-bba0332472b5', '2025-08-15T13:10:28.061+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e7eb545c-bb4e-419e-ae2f-bba0332472b5');

-- reservation_car_sht for reservation e299a696-359d-4610-8673-d0be2c516329
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e299a696-359d-4610-8673-d0be2c516329', '2025-08-15T13:10:27.98+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e299a696-359d-4610-8673-d0be2c516329');

-- reservation_car_sht for reservation b30be9f4-34c7-4df2-b816-29f9602f4c1b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b30be9f4-34c7-4df2-b816-29f9602f4c1b', '2025-08-15T13:10:27.907+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b30be9f4-34c7-4df2-b816-29f9602f4c1b');

-- reservation_car_sht for reservation a3156b28-d61f-46c6-92f0-b6dc0448aa3a
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a3156b28-d61f-46c6-92f0-b6dc0448aa3a', '2025-08-15T13:10:27.83+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a3156b28-d61f-46c6-92f0-b6dc0448aa3a');

-- reservation_car_sht for reservation 573f3401-c508-47a5-bda8-3ce2af865c49
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '573f3401-c508-47a5-bda8-3ce2af865c49', '2025-08-15T13:10:27.721+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '573f3401-c508-47a5-bda8-3ce2af865c49');

-- reservation_car_sht for reservation a6839509-21fc-4576-afea-302c7ae52e8b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a6839509-21fc-4576-afea-302c7ae52e8b', '2025-08-15T13:10:27.59+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a6839509-21fc-4576-afea-302c7ae52e8b');

-- reservation_car_sht for reservation 3dbc6aea-6a87-43b3-8e62-e4335929bfff
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3dbc6aea-6a87-43b3-8e62-e4335929bfff', '2025-08-15T13:10:27.501+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3dbc6aea-6a87-43b3-8e62-e4335929bfff');

-- reservation_car_sht for reservation 6bf32dce-d06c-4baa-bbbb-96f759a7986f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6bf32dce-d06c-4baa-bbbb-96f759a7986f', '2025-08-15T13:10:27.403+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6bf32dce-d06c-4baa-bbbb-96f759a7986f');

-- reservation_car_sht for reservation 6c90a400-3de2-4881-94c2-c23cbafd84a4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6c90a400-3de2-4881-94c2-c23cbafd84a4', '2025-08-15T13:10:27.323+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6c90a400-3de2-4881-94c2-c23cbafd84a4');

-- reservation_car_sht for reservation 8fafaa3b-384f-4446-8ce3-4f0cb874e3a4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8fafaa3b-384f-4446-8ce3-4f0cb874e3a4', '2025-08-15T13:10:27.245+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8fafaa3b-384f-4446-8ce3-4f0cb874e3a4');

-- reservation_car_sht for reservation b1abcf54-8529-4c9a-8c08-5baaf879a131
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b1abcf54-8529-4c9a-8c08-5baaf879a131', '2025-08-15T13:10:27.132+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b1abcf54-8529-4c9a-8c08-5baaf879a131');

-- reservation_car_sht for reservation 482c0097-57ff-4339-b18a-bdff6f0f1996
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '482c0097-57ff-4339-b18a-bdff6f0f1996', '2025-08-15T13:10:27.019+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '482c0097-57ff-4339-b18a-bdff6f0f1996');

-- reservation_car_sht for reservation 8ab6d11f-f11b-474f-b4cd-fab66b02893b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8ab6d11f-f11b-474f-b4cd-fab66b02893b', '2025-08-15T13:10:26.936+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8ab6d11f-f11b-474f-b4cd-fab66b02893b');

-- reservation_car_sht for reservation b5fbe0c8-3957-4c85-9780-3866827ce56c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b5fbe0c8-3957-4c85-9780-3866827ce56c', '2025-08-15T13:10:26.838+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b5fbe0c8-3957-4c85-9780-3866827ce56c');

-- reservation_car_sht for reservation 682583b4-4cb1-4b1b-88b5-3654eb419125
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '682583b4-4cb1-4b1b-88b5-3654eb419125', '2025-08-15T13:10:26.703+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '682583b4-4cb1-4b1b-88b5-3654eb419125');

-- reservation_car_sht for reservation a40dc8ba-6c32-4c47-8806-805cabf52a22
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'a40dc8ba-6c32-4c47-8806-805cabf52a22', '2025-08-15T13:10:26.617+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'a40dc8ba-6c32-4c47-8806-805cabf52a22');

-- reservation_car_sht for reservation d7b3dfe7-4bd6-4323-a8c3-bb8af5a1d65c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd7b3dfe7-4bd6-4323-a8c3-bb8af5a1d65c', '2025-08-15T13:10:26.521+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd7b3dfe7-4bd6-4323-a8c3-bb8af5a1d65c');

-- reservation_car_sht for reservation 019da24e-01ea-4c07-b349-066ece0e803d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '019da24e-01ea-4c07-b349-066ece0e803d', '2025-08-15T13:10:26.427+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '019da24e-01ea-4c07-b349-066ece0e803d');

-- reservation_car_sht for reservation 5d388f50-2901-43f7-9bc4-4e9487ba6f45
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '5d388f50-2901-43f7-9bc4-4e9487ba6f45', '2025-08-15T13:10:26.339+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '5d388f50-2901-43f7-9bc4-4e9487ba6f45');

-- reservation_car_sht for reservation 1f69979f-917a-46fe-9259-4a0b7559c364
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1f69979f-917a-46fe-9259-4a0b7559c364', '2025-08-15T13:10:26.219+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1f69979f-917a-46fe-9259-4a0b7559c364');

-- reservation_car_sht for reservation 7cee8b34-7538-4718-8110-6463820f4645
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7cee8b34-7538-4718-8110-6463820f4645', '2025-08-15T13:10:26.133+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7cee8b34-7538-4718-8110-6463820f4645');

-- reservation_car_sht for reservation ac4a9a3c-02a3-4c49-a7a3-24cf607f1399
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ac4a9a3c-02a3-4c49-a7a3-24cf607f1399', '2025-08-15T13:10:26.041+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ac4a9a3c-02a3-4c49-a7a3-24cf607f1399');

-- reservation_car_sht for reservation 573b7d31-f7f2-491a-8086-de93c4dbb075
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '573b7d31-f7f2-491a-8086-de93c4dbb075', '2025-08-15T13:10:25.968+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '573b7d31-f7f2-491a-8086-de93c4dbb075');

-- reservation_car_sht for reservation 141a61b1-7047-48be-950f-668e33d178dc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '141a61b1-7047-48be-950f-668e33d178dc', '2025-08-15T13:10:25.881+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '141a61b1-7047-48be-950f-668e33d178dc');

-- reservation_car_sht for reservation f2839509-1dac-4117-ac82-0f25b74dffc3
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'f2839509-1dac-4117-ac82-0f25b74dffc3', '2025-08-15T13:10:25.788+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'f2839509-1dac-4117-ac82-0f25b74dffc3');

-- reservation_car_sht for reservation 44c6b58c-ddcc-41c2-b31b-e613df07fdf4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '44c6b58c-ddcc-41c2-b31b-e613df07fdf4', '2025-08-15T13:10:25.71+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '44c6b58c-ddcc-41c2-b31b-e613df07fdf4');

-- reservation_car_sht for reservation af4175c3-a43b-40fd-8cef-cb7b75f7b177
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'af4175c3-a43b-40fd-8cef-cb7b75f7b177', '2025-08-15T13:10:25.633+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'af4175c3-a43b-40fd-8cef-cb7b75f7b177');

-- reservation_car_sht for reservation 37c3b434-653a-45cf-9496-eca18e1e3403
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '37c3b434-653a-45cf-9496-eca18e1e3403', '2025-08-15T13:10:25.536+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '37c3b434-653a-45cf-9496-eca18e1e3403');

-- reservation_car_sht for reservation 783a6f69-37b7-4835-83aa-fdd29e0833ec
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '783a6f69-37b7-4835-83aa-fdd29e0833ec', '2025-08-15T13:10:25.452+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '783a6f69-37b7-4835-83aa-fdd29e0833ec');

-- reservation_car_sht for reservation 762c2ab6-1de2-44d4-906b-92cf80df153e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '762c2ab6-1de2-44d4-906b-92cf80df153e', '2025-08-15T13:10:25.383+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '762c2ab6-1de2-44d4-906b-92cf80df153e');

-- reservation_car_sht for reservation bcda30f0-9c8d-42d6-8fc8-2ad240080ede
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'bcda30f0-9c8d-42d6-8fc8-2ad240080ede', '2025-08-15T13:10:25.305+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'bcda30f0-9c8d-42d6-8fc8-2ad240080ede');

-- reservation_car_sht for reservation b50bedd0-53b6-4203-b3cf-886dc6719d13
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'b50bedd0-53b6-4203-b3cf-886dc6719d13', '2025-08-15T13:10:25.212+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'b50bedd0-53b6-4203-b3cf-886dc6719d13');

-- reservation_car_sht for reservation 634d7259-ec63-4011-a4fb-132abef0079e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '634d7259-ec63-4011-a4fb-132abef0079e', '2025-08-15T13:10:25.136+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '634d7259-ec63-4011-a4fb-132abef0079e');

-- reservation_car_sht for reservation 8c904e05-bed2-4ae3-9f46-aefaa2f51b27
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '8c904e05-bed2-4ae3-9f46-aefaa2f51b27', '2025-08-15T13:10:25.056+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '8c904e05-bed2-4ae3-9f46-aefaa2f51b27');

-- reservation_car_sht for reservation e847f6d2-2b1e-4713-895d-7876d510e2be
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'e847f6d2-2b1e-4713-895d-7876d510e2be', '2025-08-15T13:10:24.981+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'e847f6d2-2b1e-4713-895d-7876d510e2be');

-- reservation_car_sht for reservation ec2dd36f-a358-4182-aac4-5a612282fb05
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ec2dd36f-a358-4182-aac4-5a612282fb05', '2025-08-15T13:10:24.897+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ec2dd36f-a358-4182-aac4-5a612282fb05');

-- reservation_car_sht for reservation c6414601-efe3-4778-a2c7-3d2019f9725f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'c6414601-efe3-4778-a2c7-3d2019f9725f', '2025-08-15T13:10:24.811+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'c6414601-efe3-4778-a2c7-3d2019f9725f');

-- reservation_car_sht for reservation fe1c7ccc-de1d-4f0d-815e-9e2c7963b206
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'fe1c7ccc-de1d-4f0d-815e-9e2c7963b206', '2025-08-15T13:10:24.738+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'fe1c7ccc-de1d-4f0d-815e-9e2c7963b206');

-- reservation_car_sht for reservation 11a1565f-b0a0-4446-90a3-0e2c31d0de50
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '11a1565f-b0a0-4446-90a3-0e2c31d0de50', '2025-08-15T13:10:24.641+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '11a1565f-b0a0-4446-90a3-0e2c31d0de50');

-- reservation_car_sht for reservation d4bc362b-95c9-41c9-8d76-9af070d452e8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd4bc362b-95c9-41c9-8d76-9af070d452e8', '2025-08-15T13:10:24.544+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd4bc362b-95c9-41c9-8d76-9af070d452e8');

-- reservation_car_sht for reservation da611c75-e737-44a7-b366-d7dda95eee1d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'da611c75-e737-44a7-b366-d7dda95eee1d', '2025-08-15T13:10:24.455+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'da611c75-e737-44a7-b366-d7dda95eee1d');

-- reservation_car_sht for reservation ad68e864-4cff-4fc8-9b82-cc418de093a6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'ad68e864-4cff-4fc8-9b82-cc418de093a6', '2025-08-15T13:10:24.319+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'ad68e864-4cff-4fc8-9b82-cc418de093a6');

-- reservation_car_sht for reservation 80652c37-576a-4611-9e79-4de2a6e74a1d
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '80652c37-576a-4611-9e79-4de2a6e74a1d', '2025-08-15T13:10:24.232+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '80652c37-576a-4611-9e79-4de2a6e74a1d');

-- reservation_car_sht for reservation 16cd1915-43cb-4647-b317-b67e9d740ae6
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '16cd1915-43cb-4647-b317-b67e9d740ae6', '2025-08-15T13:10:24.114+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '16cd1915-43cb-4647-b317-b67e9d740ae6');

-- reservation_car_sht for reservation 438796e6-440b-4467-a759-a16ad558aa88
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '438796e6-440b-4467-a759-a16ad558aa88', '2025-08-15T13:10:24.045+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '438796e6-440b-4467-a759-a16ad558aa88');

-- reservation_car_sht for reservation 51f8c12f-e563-4f32-9ea4-2749adab39f4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '51f8c12f-e563-4f32-9ea4-2749adab39f4', '2025-08-15T13:10:23.915+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '51f8c12f-e563-4f32-9ea4-2749adab39f4');

-- reservation_car_sht for reservation d05fe703-1f68-4caf-8190-9da79e6c707f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'd05fe703-1f68-4caf-8190-9da79e6c707f', '2025-08-15T13:10:23.744+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'd05fe703-1f68-4caf-8190-9da79e6c707f');

-- reservation_car_sht for reservation df4984ba-2a54-4e8c-874b-42b506f6765b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'df4984ba-2a54-4e8c-874b-42b506f6765b', '2025-08-15T13:10:23.588+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'df4984ba-2a54-4e8c-874b-42b506f6765b');

-- reservation_car_sht for reservation 9e750a90-782f-4fa6-a539-8b6ab558456e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9e750a90-782f-4fa6-a539-8b6ab558456e', '2025-08-15T13:10:23.324+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9e750a90-782f-4fa6-a539-8b6ab558456e');

-- reservation_car_sht for reservation 933dbc0f-68a2-4e25-92a9-2addc463e4fc
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '933dbc0f-68a2-4e25-92a9-2addc463e4fc', '2025-08-15T13:10:23.021+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '933dbc0f-68a2-4e25-92a9-2addc463e4fc');

-- reservation_car_sht for reservation 921a062f-6f8f-4b61-a87c-3a7220ee2954
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '921a062f-6f8f-4b61-a87c-3a7220ee2954', '2025-08-15T13:10:22.877+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '921a062f-6f8f-4b61-a87c-3a7220ee2954');

-- reservation_car_sht for reservation 4cb8ee19-39f3-49d2-9378-b53ed6128e64
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4cb8ee19-39f3-49d2-9378-b53ed6128e64', '2025-08-15T13:10:22.783+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4cb8ee19-39f3-49d2-9378-b53ed6128e64');

-- reservation_car_sht for reservation 6e7732a1-1ca2-472c-aef2-d282784e1500
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6e7732a1-1ca2-472c-aef2-d282784e1500', '2025-08-15T13:10:22.687+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6e7732a1-1ca2-472c-aef2-d282784e1500');

-- reservation_car_sht for reservation 0b2d8cf4-31e9-4583-87f4-c6ac08ddccb8
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0b2d8cf4-31e9-4583-87f4-c6ac08ddccb8', '2025-08-15T13:10:22.563+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0b2d8cf4-31e9-4583-87f4-c6ac08ddccb8');

-- reservation_car_sht for reservation 9666f268-9881-4a8a-a2dc-70445c1cf95b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '9666f268-9881-4a8a-a2dc-70445c1cf95b', '2025-08-15T13:10:22.475+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '9666f268-9881-4a8a-a2dc-70445c1cf95b');

-- reservation_car_sht for reservation 74ab6a54-d455-4e48-9890-ed3fd20f0970
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '74ab6a54-d455-4e48-9890-ed3fd20f0970', '2025-08-15T13:10:22.351+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '74ab6a54-d455-4e48-9890-ed3fd20f0970');

-- reservation_car_sht for reservation 1576fa1a-8ff3-4d24-95a4-2546c9d1bfcb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '1576fa1a-8ff3-4d24-95a4-2546c9d1bfcb', '2025-08-15T13:10:22.211+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '1576fa1a-8ff3-4d24-95a4-2546c9d1bfcb');

-- reservation_car_sht for reservation 32285b7c-b307-4da1-bc6b-097693880176
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '32285b7c-b307-4da1-bc6b-097693880176', '2025-08-15T13:10:22.123+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '32285b7c-b307-4da1-bc6b-097693880176');

-- reservation_car_sht for reservation 7470b35d-711f-47c4-93aa-c8e4f789e742
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '7470b35d-711f-47c4-93aa-c8e4f789e742', '2025-08-15T13:10:22.044+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '7470b35d-711f-47c4-93aa-c8e4f789e742');

-- reservation_car_sht for reservation 45912312-9dcc-4e75-84f7-50a6104caba7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '45912312-9dcc-4e75-84f7-50a6104caba7', '2025-08-15T13:10:21.967+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '45912312-9dcc-4e75-84f7-50a6104caba7');

-- reservation_car_sht for reservation 3b02d65c-2b5f-4edd-bc12-f31846a2a5b4
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3b02d65c-2b5f-4edd-bc12-f31846a2a5b4', '2025-08-15T13:10:21.866+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3b02d65c-2b5f-4edd-bc12-f31846a2a5b4');

-- reservation_car_sht for reservation 3de586a0-4d90-4e10-8b6d-0aacd365691f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '3de586a0-4d90-4e10-8b6d-0aacd365691f', '2025-08-15T13:10:21.786+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '3de586a0-4d90-4e10-8b6d-0aacd365691f');

-- reservation_car_sht for reservation 0ed60b7c-2023-4796-86e7-55acd214b173
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '0ed60b7c-2023-4796-86e7-55acd214b173', '2025-08-15T13:10:21.694+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '0ed60b7c-2023-4796-86e7-55acd214b173');

-- reservation_car_sht for reservation 17638feb-3c2f-4598-869f-0abaf5604d99
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '17638feb-3c2f-4598-869f-0abaf5604d99', '2025-08-15T13:10:21.598+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '17638feb-3c2f-4598-869f-0abaf5604d99');

-- reservation_car_sht for reservation 226ae4b7-a886-4f51-81f3-e8a446b2055f
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '226ae4b7-a886-4f51-81f3-e8a446b2055f', '2025-08-15T13:10:21.502+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '226ae4b7-a886-4f51-81f3-e8a446b2055f');

-- reservation_car_sht for reservation 88c9ab6d-0a28-41f1-90da-5456fd90418c
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '88c9ab6d-0a28-41f1-90da-5456fd90418c', '2025-08-15T13:10:21.376+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '88c9ab6d-0a28-41f1-90da-5456fd90418c');

-- reservation_car_sht for reservation db17d634-20b1-4353-9370-37c9b83fc3b7
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'db17d634-20b1-4353-9370-37c9b83fc3b7', '2025-08-15T13:10:21.28+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'db17d634-20b1-4353-9370-37c9b83fc3b7');

-- reservation_car_sht for reservation 6512c7fb-8fef-4544-b440-dc86445774ea
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '6512c7fb-8fef-4544-b440-dc86445774ea', '2025-08-15T13:10:21.176+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '6512c7fb-8fef-4544-b440-dc86445774ea');

-- reservation_car_sht for reservation df25ec1f-fd0b-4c04-8534-22bc498c7452
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'df25ec1f-fd0b-4c04-8534-22bc498c7452', '2025-08-15T13:10:21.067+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'df25ec1f-fd0b-4c04-8534-22bc498c7452');

-- reservation_car_sht for reservation 02ac73e1-fc18-42b4-ba5a-55f03344bc68
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '02ac73e1-fc18-42b4-ba5a-55f03344bc68', '2025-08-15T13:10:20.962+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '02ac73e1-fc18-42b4-ba5a-55f03344bc68');

-- reservation_car_sht for reservation fb041f27-14ca-4acb-8d0f-35b02bf5c9eb
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT 'fb041f27-14ca-4acb-8d0f-35b02bf5c9eb', '2025-08-15T13:10:20.857+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = 'fb041f27-14ca-4acb-8d0f-35b02bf5c9eb');

-- reservation_car_sht for reservation 749690c2-17e3-4f2c-b12b-e54643b1d67e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '749690c2-17e3-4f2c-b12b-e54643b1d67e', '2025-08-15T13:10:20.753+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '749690c2-17e3-4f2c-b12b-e54643b1d67e');

-- reservation_car_sht for reservation 4b1e72e6-ed5c-4771-aec0-71820c7ad666
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '4b1e72e6-ed5c-4771-aec0-71820c7ad666', '2025-08-15T13:10:20.654+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '4b1e72e6-ed5c-4771-aec0-71820c7ad666');

-- reservation_car_sht for reservation 37b05bc0-faa3-4824-8a97-3271d08b1d1b
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '37b05bc0-faa3-4824-8a97-3271d08b1d1b', '2025-08-15T13:10:20.55+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '37b05bc0-faa3-4824-8a97-3271d08b1d1b');

-- reservation_car_sht for reservation 657efdf0-6750-42b7-af2c-d957cd488a0e
INSERT INTO reservation_car_sht (reservation_id, usage_date, vehicle_number)
SELECT '657efdf0-6750-42b7-af2c-d957cd488a0e', '2025-08-15T13:10:20.419+00:00', NULL
WHERE NOT EXISTS (SELECT 1 FROM reservation_car_sht WHERE reservation_id = '657efdf0-6750-42b7-af2c-d957cd488a0e');

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
