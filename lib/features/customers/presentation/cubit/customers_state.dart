import 'package:equatable/equatable.dart';
import 'package:primelayer_admin_panel/core/pagination/page_slice.dart';
import 'package:primelayer_admin_panel/features/customers/domain/customer.dart';

class CustomersState extends Equatable {
  const CustomersState({
    required this.customers,
    this.query = '',
    this.page = 0,
    this.notice,
  });

  final List<Customer> customers;
  final String query;
  final int page;
  final String? notice;

  List<Customer> get filteredCustomers {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return customers;
    return [
      for (final customer in customers)
        if (customer.name.toLowerCase().contains(needle) ||
            customer.email.toLowerCase().contains(needle) ||
            customer.city.toLowerCase().contains(needle))
          customer,
    ];
  }

  int get safePage => PageSlice.clampPage(page, filteredCustomers.length);

  List<Customer> get pagedCustomers =>
      PageSlice.of(filteredCustomers, safePage);

  Customer? byId(String id) {
    for (final customer in customers) {
      if (customer.id == id) return customer;
    }
    return null;
  }

  String nameFor(String id) => byId(id)?.name ?? 'Unknown customer';

  CustomersState copyWith({
    List<Customer>? customers,
    String? query,
    int? page,
    String? notice,
    bool clearNotice = false,
  }) {
    return CustomersState(
      customers: customers ?? this.customers,
      query: query ?? this.query,
      page: page ?? this.page,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [customers, query, page, notice];
}
