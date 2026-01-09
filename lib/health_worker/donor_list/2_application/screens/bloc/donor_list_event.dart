part of 'donor_list_bloc.dart';

enum SearchType { name, bloodType, all, address, phone }

abstract class DonorListEvent extends Equatable {
  const DonorListEvent();

  @override
  List<Object> get props => [];
}

class LoadDonors extends DonorListEvent {}

class RefreshDonors extends DonorListEvent {}

class SearchDonors extends DonorListEvent {
  final String query;
  final SearchType searchType;
  final String bloodType;

  const SearchDonors({
    required this.query,
    this.searchType = SearchType.all,
    this.bloodType = '',
  });

  @override
  List<Object> get props => [query, searchType, bloodType];
}
