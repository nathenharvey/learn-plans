pkg_origin=learn
pkg_name=national-parks
pkg_description="A sample JavaEE Web app deployed in Tomcat8"
pkg_version=0.1.5
pkg_maintainer="First Last <you@example.com>"
pkg_license=('Apache-2.0')
pkg_source=https://github.com/billmeyer/national-parks/archive/v${pkg_version}.tar.gz
pkg_shasum=7f21dc6e0c8f7f48a2bdbb366f3bfa13e161813282f03ba09a135f8b945e4f16
pkg_upstream_url=https://github.com/billmeyer/national-parks
pkg_deps=(core/tomcat8 core/jdk8 core/mongo-tools)
pkg_build_deps=(core/maven)
pkg_exports=(
  [port]=port
)
pkg_exposes=(port)

pkg_binds=(
  [database]="port"
)

pkg_svc_user="root"
pkg_svc_group="root"

do_build() {
  build_line "do_build() ====================================="
  # Maven requires JAVA_HOME to be set, and can be set via:
  export JAVA_HOME=$(hab pkg path core/jdk8)
  mvn package
}
do_install() {
  build_line "do_install() ==================================="
  # The files created during do_build() need to be copied into the
  # tomcat webapps directory.
  local webapps_dir="$(hab pkg path core/tomcat8)/tc/webapps"
  cp target/${pkg_name}.war ${webapps_dir}/
  # Seed data will be loaded into Mongo using our init hook
  cp target/${pkg_name}.war ${pkg_prefix}
  cp national-parks.json ${pkg_prefix}
}
