# Class: quartermaster::windowsmedia
#
# This Class defines Windows Media to the pxe infrastructrure
# based on the name of the ISO provided
# ISOs can be take offical unmodified ISOs and it will parse the name
# determining infromation to generate unattend.xml for the media
#
# Parameters: none
#
# Actions:
#
# Sample Usage:
#    quartermaster::windowsmedia{"en_windows_8_enterprise_x86_dvd_917587.iso": activationkey => "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"}
#

define quartermaster::windowsmedia( $activationkey ) {

  $isofile  = $name
#    $iso_path = "/srv/quartermaster/WinPE/ISO/${name}"
  $iso_path = "${::windows_isos}/${name}"

# Windows Server 2012
  if $name =~ /([a-z]+)_([a-zA-Z_\-]+)_([0-9]+)_([x0-9]+)_dvd_([0-9]+).iso/ {
    $w_lang          = $1
    $w_dist          = $2
    $w_release       = $3
    $w_media_arch    = $4
    $w_build         = $5
  }
# Windows Server 2012 R2
  if $name =~ /([a-z]+)_([a-zA-Z_\-]+)_([0-9]+)_(r2)_([x0-9]+)_dvd_([0-9]+).iso/ {
    $w_lang          = $1
    $w_dist          = $2
    $w_release       = "${3}${4}"
    $w_media_arch    = $5
    $w_build         = $6
  }

# Windows 8
#if $name =~ /([a-z]+)_([a-zA-Z]+)_([0-9]+)_([a-zA-Z]+)_([x0-9]+)_dvd_([0-9]+).iso/ {
  if $name =~ /([a-z]+)_([a-zA-Z]+)_([0-9]_[a-zA-Z]+)_([x0-9]+)_dvd_([0-9]+).iso/ {
    $w_lang          = $1
    $w_dist          = $2
    $w_release       = $3
    $w_media_arch    = $4
    $w_build         = $5
  }
# Windows 8.1
#if $name =~ /([a-z]+)_([a-zA-Z]+)_([0-9]+)_([a-zA-Z]+)_([x0-9]+)_dvd_([0-9]+).iso/ {
  if $name =~ /([a-z]+)_([a-zA-Z]+)_([0-9]_[0-9]_[a-zA-Z]+)_([x0-9]+)_dvd_([0-9]+).iso/ {
    $w_lang          = $1
    $w_dist          = $2
    $w_release       = $3
    $w_media_arch    = $4
    $w_build         = $5
  }

  $w_distro = $w_dist ?{
    /(microsoft_hyper-v_server)/    => 'hyper-v',
    /(windows_server)/              => 'server',
    default                         => $w_dist,
  }

  $w_arch = $w_media_arch ?{
    /(x64)/ => 'amd64',
    /(x86)/ => 'i386',
  }
  $w_flavor = "${w_distro}-${w_release}-${w_arch}"

#  $w_menu_option = $w_dist ?{
#    /(windows_server)/           =>'S',
#    /(microsoft_hyper-v_server)/ =>'V',
#    /(windows)/                  =>'W',
#  }
  $w_menu_option = $w_flavor ?{
    # Client
    /(windows-8_enterprise-i386)/    =>'A',
    /(windows-8_enterprise-amd64)/   =>'B',
    /(windows-8_1_enterprise-i386)/  =>'C',
    /(windows-8_1_enterprise-amd64)/ =>'D',
    # Hypervisor
    /(hyper-v-2012-amd64)/           =>'E',
    /(hyper-v-2012r2-amd64)/         =>'F',
    /(hyper-v-2012r2-amd64)/         =>'G',
    /(hyper-v-2016-amd64)/           =>'H',
    # Server x64
    /(server-2012-amd64)/            =>'I',
    /(server-2012r2-amd64)/          =>'J',
    /(server-2016-amd64)/            =>'K',
    # Server x32
    /(server-2012-i386)/             =>'L',
    /(server-2012r2-i386)/           =>'N',
    /(server-2016-amd64)/            =>'O',
  }
  $w_media_image_name = $w_flavor ?{
    /(windows-8_enterprise-i386)/       =>'Windows 8 ENTERPRISE',
    /(windows-8_enterprise-amd64)/      =>'Windows 8 ENTERPRISE',
    /(windows-8_professional-i386)/     =>'Windows 8 PROFESSIONAL',
    /(windows-8_professional-amd64)/    =>'Windows 8 PROFESSIONAL',
    /(windows-8_1_enterprise-i386)/     =>'Windows 8.1 ENTERPRISE',
    /(windows-8_1_enterprise-amd64)/    =>'Windows 8.1 ENTERPRISE',
    /(windows-8_1_professional-i386)/   =>'Windows 8.1 PROFESSIONAL',
    /(windows-8_1_professional-amd64)/  =>'Windows 8.1 PROFESSIONAL',
    /(hyper-v-2012-amd64)/              =>'Hyper-V Server 2012 SERVERHYPERCORE',
    /(hyper-v-2012r2-amd64)/            =>'Hyper-V Server 2012 R2 SERVERHYPERCORE',
    /(hyper-v-2016-amd64)/              =>'Hyper-V Server 2016 SERVERHYPERCORE',
    /(server-2012-i386)/                =>'Windows Server 2012 SERVERDATACENTER',
    /(server-2012-amd64)/               =>'Windows Server 2012 SERVERDATACENTER',
    /(server-2012r2-i386)/              =>'Windows Server 2012 R2 SERVERDATACENTER',
    /(server-2012r2-amd64)/             =>'Windows Server 2012 R2 SERVERDATACENTER',
    /(server-2016-i386)/                =>'Windows Server 2016 SERVERDATACENTER',
    /(server-2016-amd64)/               =>'Windows Server 2016 SERVERDATACENTER',
# If you want to use Standard Licensing "Windows Server 2012 SERVERSTANDARD"
# If you want to use Standard Licensing "Windows Server 2012 SERVERSTANDARD"
  }

#  $w_flavor = $w_dist ?{
#    /(windows_server)/           =>'server',
#    /(microsoft_hyper-v_server)/ =>'hyper-v',
#    /(windows)/                  =>'client',
#  }

  notify {"${name}: WINDOWS LANGUAGE: ${w_lang}": }
  notify {"${name}: WINDOWS DISTRIBUTION ${w_distro}": }
  notify {"${name}: WINDOWS RELEASE: ${w_release}": }
  notify {"${name}: WINDOWS MEDIA ARCH: ${w_media_arch}": }
  notify {"${name}: WINDOWS BUILD NUMBER: ${w_build}": }
  notify {"${name}: WINDOWS ARCH: ${w_arch}": }
  notify {"${name}: WINDOWS FLAVOR: ${w_flavor}":}
  notify {"${name}: WINDOWS MEDIA IMAGE NAME: ${w_media_image_name}":}

  case $w_media_image_name {
    'windows-10-amd64':{
      $iso_media_download_url = 'http://care.dlservice.microsoft.com/dl/download/B/8/B/B8B452EC-DD2D-4A8F-A88C-D2180C177624/15063.0.170317-1834.RS2_RELEASE_CLIENTENTERPRISEEVAL_OEMRET_X64FRE_EN-US.ISO'
    }
    'server-2012r2-amd64':{
      $iso_media_download_url = 'http://care.dlservice.microsoft.com/dl/download/6/2/A/62A76ABB-9990-4EFC-A4FE-C7D698DAEB96/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_EN-US-IR3_SSS_X64FREE_EN-US_DV9.ISO'
    }
    'hyper-v-2012-amd64':{
      $iso_media_download_url = 'http://care.dlservice.microsoft.com/dl/download/3/4/7/347A95F0-A63C-492F-BE43-F376AE30C9FE/9200.16384.WIN8_RTM.120725-1247_X64FRE_SERVERHYPERCORE_EN-US-HRM_SHV_X64FRE_EN-US_DV5.ISO'
    }
    'hyper-v-2012r2-amd64':{
      $iso_media_download_url = 'http://care.dlservice.microsoft.com/dl/download/F/7/D/F7DF966B-5C40-4674-9A32-D83D869A3244/9600.16384.WINBLUE_RTM.130821-1623_X64FRE_SERVERHYPERCORE_EN-US-IRM_SHV_X64FRE_EN-US_DV5.ISO'
    }
    'hyper-v-2016-amd64':{
      $iso_media_download_url = 'http://care.dlservice.microsoft.com/dl/download/E/4/E/E4EFC175-3D2D-49A6-B6D9-1B389887F764/14393.0.160916-1106.RS1_REFRESH_SERVERHYPERCORE_OEM_X64FRE_EN-US.ISO'
    }
    default:{
      warning("No installation media iso for ${w_media_image_name}")
    }
  }
  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}"]) {
    file { "/srv/quartermaster/microsoft/${w_distro}":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require =>  File[ '/srv/quartermaster/microsoft' ],
    }
  }
  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}/${w_release}"]) {
    file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require =>  File[ '/srv/quartermaster/microsoft' ],
    }
  }
  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/unattend"]) {
    file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/unattend":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require =>  File[ '/srv/quartermaster/microsoft' ],
    }
  }
  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe"]) {
    file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require =>  File[ '/srv/quartermaster/microsoft' ],
    }
  }
  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}"]) {
    file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}":
      ensure  => directory,
#      recurse => true,
#      owner   => 'www-data',
#      group   => 'www-data',
#      mode    => '0644',
      require =>  File[ "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe"],
    }
  }
  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot"]) {
    file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot":
      ensure  => directory,
      recurse => true,
      owner   => 'www-data',
      group   => 'www-data',
      mode    => '0644',
      require =>  File[ "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe"],
    }
  }
  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/${w_arch}"]) {
    file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/${w_arch}":
      ensure  => link,
#      owner   => 'www-data',
#      group   => 'www-data',
#      mode    => '0644',
      target  => "/srv/quartermaster/microsoft/mount/${name}",
      require =>  File[ '/srv/quartermaster/microsoft' ],
    }
  }
  file{"/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/startnet.cmd":
    ensure  => file,
    content => template('quartermaster/winpe/startnet.cmd.erb'),
    require =>  File[ "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe"],
  }
  staging::file{"${w_flavor}-winpe.wim":
    source  => "http://${::fqdn}/microsoft/mount/${name}/sources/boot.wim",
    target  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/${w_arch}.wim",
    require => File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/startnet.cmd"],
#    notify  => Exec["wimlib-imagex-mount-${name}"],
    notify  => Exec["wimlib-imagex-delete-startnet.cmd-${name}"],
  }


  #  exec { "copy-${w_flavor}-winpe.wim":
  #    command   => "/usr/bin/wget -cv http://${::fqdn}/microsoft/mount/${name}/sources/boot.wim -O ${w_arch}.wim",
  #    creates   => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/${w_arch}.wim",
  #    cwd       => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/",
  #    notify    => Exec["wimlib-imagex-mount-${name}"],
  #    require   => File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe"],
  #    logoutput => true,
  #  }
  # file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/${w_arch}.wim":
  #   ensure => present,
  #   require => Exec["copy-${w_flavor}-winpe.wim"]
  # }

#  }
#  if ! defined (File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/etfsboot.com"]) {
#    exec { ${name}-etfsboot.com
#       command => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/etfsboot.com":
#      ensure  => directory,
#      recurse => true,
#      source  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/${w_arch}/boot/etfsboot.com",
#      owner   => 'www-data',
#      group   => 'www-data',
#      mode    => '0644',
#      require =>  File[ "/srv/quartermaster/microsoft/${w_distro}/${w_release}/${w_arch}"],
#    }
#  }
  exec {"wimlib-imagex-delete-startnet.cmd-${name}":
    command     => "/usr/bin/wimlib-imagex update ${w_arch}.wim 1 --command 'delete windows/system32/startnet.cmd'",
    cwd         => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    refreshonly => true,
    require     => Staging::File["${w_flavor}-winpe.wim"],
    notify      => Exec["wimlib-imagex-replace-startnet.cmd-${name}"],
    logoutput   => true,
  }
  exec {"wimlib-imagex-replace-startnet.cmd-${name}":
    command     => "/usr/bin/wimlib-imagex update ${w_arch}.wim 1 --command 'add ./startnet.cmd windows/system32/startnet.cmd'",
    cwd         => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    refreshonly => true,
    require     => Exec["wimlib-imagex-delete-startnet.cmd-${name}"],
    notify      => Exec["wimlib-imagex-mount-${name}"],
    logoutput   => true,
  }

  exec {"wimlib-imagex-mount-${name}":
#    command     => "/usr/bin/wimlib-imagex mount ${w_arch}.wim 'Microsoft Windows PE (x64)' mnt.${w_arch}",
#    command     => "/usr/bin/wimlib-imagex mount ${w_arch}.wim 'Microsoft Windows Setup (x64)' mnt.${w_arch}",
    command     => "/usr/bin/wimlib-imagex mount ${w_arch}.wim 1 mnt.${w_arch}",
    cwd         => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    refreshonly => true,
    require     => [
      File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}"],
      Staging::File["${w_flavor}-winpe.wim"],
    ],
  #  require     => File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}",
  #                      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/${w_arch}.wim"],
  #  notify      => Exec["wimlib-imagex-unmount-${name}"],
    logoutput   => true,
  }

  exec{"${name}-winpe-pxeboot.com":
    command   => "/bin/cp /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/windows/Boot/PXE/pxeboot.com /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/pxeboot.com",
    cwd       => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates   => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/pxeboot.com",
    require   => Exec["wimlib-imagex-mount-${name}"],
    logoutput => true,
#    notify   => Exec["wimlib-imagex-unmount-${name}"],
  }
#  staging::file{"${name}-winpe-pxeboot.com":
#    source  => "http://${::fqdn}/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/pxeboot.com",
#    source  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/pxeboot.com",
#    target  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/pxeboot.com",
#    require => Exec["wimlib-imagex-mount-${name}"],
#    notify      => Exec["wimlib-imagex-unmount-${name}"],
#  }
  exec{"${name}-winpe-pxeboot.0":
    command => "/bin/cp /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/windows/Boot/PXE/pxeboot.n12 /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/pxeboot.0",
    cwd     => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/pxeboot.0",
    require => Exec["${name}-winpe-pxeboot.com"],
  }
#  staging::file{"${name}-winpe-pxeboot.0":
#    source  => "http://${::fqdn}/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/pxeboot.n12",
#    source  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/pxeboot.n12",
#    target  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/pxeboot.0",
#    require => Staging::File["${name}-winpe-pxeboot.com"],
#    notify  => Exec["wimlib-imagex-unmount-${name}"],
#  }
  exec{"${name}-winpe-bootmgr.exe":
    command => "/bin/cp /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/windows/Boot/PXE/bootmgr.exe /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/bootmgr.exe",
    cwd     => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/bootmgr.exe",
    require => Exec["${name}-winpe-pxeboot.0"],
  }
#  staging::file{"${name}-winpe-bootmgr.exe":
#    source  => "http://${::fqdn}/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/bootmgr.exe",
#    source  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/bootmgr.exe",
#    target  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/bootmgr.exe",
#    require => Staging::File["${name}-winpe-pxeboot.0"],
#    notify      => Exec["wimlib-imagex-unmount-${name}"],
#  }
  exec{"${name}-winpe-abortpxe.com":
    command => "/bin/cp /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/windows/Boot/PXE/abortpxe.com /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/abortpxe.com",
    cwd     => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/abortpxe.com",
    require => Exec["${name}-winpe-bootmgr.exe"],
  }
#  staging::file{"${name}-winpe-abortpxe.com":
#    source  => "http://${::fqdn}/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/abortpxe.com",
#    source  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/abortpxe.com",
#    target  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/abortpxe.com",
#    require => Staging::File["${name}-winpe-bootmgr.exe"],
#    notify  => Exec["wimlib-imagex-unmount-${name}"],
#  }
  exec{"${name}-winpe-boot.sdi":
    command => "/bin/cp /srv/quartermaster/microsoft/${w_distro}/${w_release}/${w_arch}/boot/boot.sdi /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/boot.sdi",
    cwd     => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/boot.sdi",
    require => Exec["${name}-winpe-abortpxe.com"],
  }
#  staging::file{"${name}-winpe-boot.sdi":
#    source  => "http://${::fqdn}/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/boot.sdi",
#    source  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}/Windows/Boot/PXE/boot.sdi",
#    target  => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/boot.sdi",
#    require => Staging::File["${name}-winpe-abortpxe.com"],
#    notify  => Exec["wimlib-imagex-unmount-${name}"],
#  }

  exec{"${name}-bcd":
    command => "/bin/cp /srv/quartermaster/microsoft/${w_distro}/${w_release}/${w_arch}/boot/bcd /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/bcd",
    cwd     => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/bcd",
    require => Exec["${name}-winpe-boot.sdi"],
  }
  exec{"${name}-copy_winpe_fonts":
    command   => "/bin/cp -R /srv/quartermaster/microsoft/${w_distro}/${w_release}/${w_arch}/boot/fonts /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts",
    cwd       => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates   => [
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/chs_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/cht_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/jpn_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/kor_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/malgun_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/malgunn_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/malgun_console.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/meiryo_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/meiryo_console.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/meiryon_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/msjh_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/msjhn_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/msjh_console.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/msyh_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/msyhn_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/msyh_console.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/segmono_boot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/segoe_slboot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/segoen_slboot.ttf",
      "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/fonts/wlg4_boot.ttf",
    ],
    require   => Exec["${name}-bcd"],
    notify    => Exec["wimlib-imagex-unmount-${name}"],
    logoutput => true,
  }

  exec {"wimlib-imagex-unmount-${name}":
    command     => "/usr/bin/wimlib-imagex unmount mnt.${w_arch} --commit",
    cwd         => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    refreshonly => true,
    require     => File["/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/mnt.${w_arch}"],
    logoutput   => true,
    notify      => Exec["${name}-boot.wim"],
  }

  exec{"${name}-boot.wim":
    command     => "/bin/cp /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/${w_arch}.wim /srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/boot.wim",
    cwd         => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe",
    creates     => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/pxe/Boot/boot.wim",
    refreshonly => true,
    require     => Exec["wimlib-imagex-unmount-${name}"],
  }
  file { "/srv/quartermaster/microsoft/winpe/system/${name}.cmd":
    ensure  => file,
    mode    => $quartermaster::exe_mode,
    content => template('quartermaster/winpe/menu/default.erb'),
  }

  file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/unattend/${w_flavor}.xml":
    ensure  => file,
    mode    => $quartermaster::exe_mode,
    content => template('quartermaster/autoinst/unattend.erb'),
  }
  file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/unattend/${w_flavor}-cloudbase.xml":
    ensure  => file,
    mode    => $quartermaster::exe_mode,
    path    => "/srv/quartermaster/microsoft/${w_distro}/${w_release}/unattend/${w_flavor}-cloudbase.xml",
    content => template('quartermaster/autoinst/Cloudbase.erb'),
  }
  file { "/srv/quartermaster/microsoft/${w_distro}/${w_release}/unattend/${w_flavor}-compute.xml":
    ensure  => file,
    mode    => $quartermaster::exe_mode,
    content => template('quartermaster/autoinst/compute.erb'),
  }

  concat::fragment{"winpe_system_cmd_a_init_${name}":
    target  => '/srv/quartermaster/microsoft/winpe/system/setup.cmd',
    content => template('quartermaster/winpe/menu/A_init.erb'),
    order   => 05,
  }
  concat::fragment{"winpe_system_cmd_b_init_${name}":
    target  => '/srv/quartermaster/microsoft/winpe/system/setup.cmd',
    content => template('quartermaster/winpe/menu/B_init.erb'),
    order   => 15,
  }
  concat::fragment{"winpe_system_cmd_c_init_${name}":
    target  => '/srv/quartermaster/microsoft/winpe/system/setup.cmd',
    content => template('quartermaster/winpe/menu/C_init.erb'),
    order   => 25,
  }

}
