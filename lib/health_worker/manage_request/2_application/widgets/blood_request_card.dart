import 'package:bloodconnect/donor_finder/request_screen/1_domain/entities/blood_request_entity.dart';
import 'package:bloodconnect/health_worker/manage_request/2_application/screens/bloc/manage_request_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BloodRequestCard extends StatelessWidget {
  final BloodRequestEntity request;

  const BloodRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.patientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(request.requestStatus),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Blood Group', request.bloodType),
            const SizedBox(height: 8),
            _buildInfoRow('Hospital', request.hospital),
            const SizedBox(height: 8),
            _buildInfoRow('Units Required', '${request.units} units'),
            const SizedBox(height: 8),
            _buildInfoRow('Urgency', request.urgencyLevel),
            const SizedBox(height: 8),
            _buildInfoRow(
                'Date', request.createdAt?.toString().split(' ')[0] ?? 'N/A'),
            if (request.reason.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Reason', request.reason),
            ],
            if (request.additionalInfo.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Additional Info', request.additionalInfo),
            ],
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.local_hospital,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.hospital,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (request.requestStatus == RequestStatus.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => _showRejectConfirmation(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text('Reject'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _showApproveConfirmation(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Approve'),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              _handleButtonAction(context);
            },
            child: Text(
              _getActionButtonText(request.requestStatus),
            ),
          ),
        ],
      );
    }
  }

  void _showApproveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Request'),
        content: Text(
            'Are you sure you want to approve this blood request from ${request.patientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ManageRequestScreenBloc>().add(
                    UpdateRequestStatusEvent(
                      requestId: request.id!,
                      newStatus: RequestStatus.approved,
                      currentFilter: request.requestStatus,
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Blood request approved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: Text(
            'Are you sure you want to reject this blood request from ${request.patientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ManageRequestScreenBloc>().add(
                    UpdateRequestStatusEvent(
                      requestId: request.id!,
                      newStatus: RequestStatus.rejected,
                      currentFilter: request.requestStatus,
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Blood request rejected'),
                  backgroundColor: Colors.grey,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _handleButtonAction(BuildContext context) {
    switch (request.requestStatus) {
      case RequestStatus.pending:
        break;
      case RequestStatus.approved:
        _showCompleteConfirmation(context);
        break;
      case RequestStatus.rejected:
        _showReconsiderOptions(context);
        break;
    }
  }

  void _showReconsiderOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reconsider Request'),
        content: Text(
            'What would you like to do with ${request.patientName}\'s rejected blood request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // Update the request status to pending
              context.read<ManageRequestScreenBloc>().add(
                    UpdateRequestStatusEvent(
                      requestId: request.id!,
                      newStatus: RequestStatus.pending,
                      currentFilter: request.requestStatus,
                    ),
                  );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Blood request status changed to pending'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Mark as Pending'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // Show complete confirmation dialog
              _showCompleteConfirmation(context);
            },
            child: const Text('Complete & Delete'),
          ),
        ],
      ),
    );
  }

  void _showCompleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Request'),
        content: Text(
            'Has this blood request for ${request.patientName} been fulfilled? This will permanently delete the request.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              context.read<ManageRequestScreenBloc>().add(
                    DeleteRequestEvent(
                      requestId: request.id!,
                      currentFilter: request.requestStatus,
                    ),
                  );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Blood request completed and removed from system'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(RequestStatus status) {
    Color color;
    switch (status) {
      case RequestStatus.pending:
        color = Colors.orange;
        break;
      case RequestStatus.approved:
        color = Colors.green;
        break;
      case RequestStatus.rejected:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toString().split('.').last,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getActionButtonText(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Approve';
      case RequestStatus.approved:
        return 'Complete';
      case RequestStatus.rejected:
        return 'Reconsider';
    }
  }
}
