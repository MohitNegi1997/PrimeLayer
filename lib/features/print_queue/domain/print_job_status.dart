enum PrintJobStatus {
  queued,
  printing,
  paused,
  failed,
  done;

  String get label => switch (this) {
    PrintJobStatus.queued => 'Queued',
    PrintJobStatus.printing => 'Printing',
    PrintJobStatus.paused => 'Paused',
    PrintJobStatus.failed => 'Failed',
    PrintJobStatus.done => 'Done',
  };
}
