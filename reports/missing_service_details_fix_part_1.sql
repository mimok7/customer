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

COMMIT;
