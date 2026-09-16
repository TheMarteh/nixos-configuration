{ ... }:

{
  users.users.steal = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker" # Enable docker usage for the user.
      "adbusers" # Enable adb usage for the user.
    ];
    # Gebruikerspakketten staan in ./home
  };
}
