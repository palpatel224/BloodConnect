part of 'donor_list_bloc.dart';

abstract class DonorListState extends Equatable {
  const DonorListState();

  @override
  List<Object> get props => [];
}

class DonorListInitial extends DonorListState {}

class DonorListLoading extends DonorListState {}

class DonorListLoaded extends DonorListState {
  final List<DonorEntity> donors;
  final bool isFiltered;

  const DonorListLoaded({
    required this.donors,
    this.isFiltered = false,
  });

  @override
  List<Object> get props => [donors, isFiltered];
}

class DonorListError extends DonorListState {
  final String message;

  const DonorListError({required this.message});

  @override
  List<Object> get props => [message];
}
