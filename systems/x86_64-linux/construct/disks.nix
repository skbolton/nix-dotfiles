{ ... }:

{
  disko.devices.disk.main = {
    type = "disk";
    # only one nvme slot on this machine so this feels safe
    device = "/dev/disk/by-id/nvme-CT2000T710SSD8_25305262B5DB";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "550M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing partition
            # Subvolumes must set a mountpoint in order to be mounted,
            # unless their parent is mounted
            subvolumes = {
              # Subvolume name is different from mountpoint
              "@" = {
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "space_cache=v2" "noatime" ];
              };
              # Subvolume name is the same as the mountpoint
              "@home" = {
                mountOptions = [ "compress=zstd" "space_cache=v2" "noatime" ];
                mountpoint = "/home";
              };
              # Parent is not mounted so the mountpoint must be set
              "@nix" = {
                mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                mountpoint = "/nix";
              };

              "@var/log" = {
                mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                mountpoint = "/var/log";
              };

              "@var/zion-data" = {
                mountOptions = [ "compress=zstd" "noatime" "space_cache=v2" ];
                mountpoint = "/var/zion-data";
              };
            };
          };
        };
      };
    };
  };
}

