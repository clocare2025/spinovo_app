class ServiceData {
  final List<Map<String, dynamic>> servicePrice = [
    {
      'service_id': 1,
      "service": "Ironing",
      "original": 15,
      "discounted": 12,
      "prices_by_qty": [
        {"qty": 5},
        {"qty": 10},
        {"qty": 20},
        {"qty": 30},
      ]
    },
    {
      'service_id': 2,
      "service": "wash",
      "original": 20,
      "discounted": 15,
      "prices_by_qty": [
        {"qty": 5},
        {"qty": 10},
        {"qty": 20},
        {"qty": 30},
      ]
    },
    {
      'service_id': 3,
      "service": "wash + Ironing",
      "original": 30,
      "discounted": 25,
      "prices_by_qty": [
        {"qty": 5},
        {"qty": 10},
        {"qty": 20},
        {"qty": 30},
      ]
    },
    {
      'service_id': 4,
      "service": "Dry Cleaning",
      "original": 120,
      "discounted": 100,
      "prices_by_qty": [
        {"qty": 5},
        {"qty": 10},
        {"qty": 20},
        {"qty": 30},
      ]
    },
    {
      'service_id': 5,
      "service": "Shoes Cleaning",
      "original": 40,
      "discounted": 30,
      "prices_by_qty": [
        {"qty": 2},
        {"qty": 3},
        {"qty": 5},
        {"qty": 6},
      ]
    },
  ];
}