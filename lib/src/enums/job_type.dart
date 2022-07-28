enum JobType {

  readJsonFromUrl('read_json_from_url'),
  downloadAuthToken('download_auth_token'),
  unzip('unzip'),
  runCommand('run_command'),
  deleteFolder('delete_folder');

  const JobType(this.name);
  final String name;

  static JobType? fromString(String name) {
    final item = JobType.values.where((element) => element.name.toLowerCase() == name.toLowerCase());
    return item.isEmpty ? null : item.first;
  }

}