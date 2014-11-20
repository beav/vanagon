require 'vanagon/utilities'
include Vanagon::Utilities

class Vanagon::Platform
  class RPM < Vanagon::Platform
    def generate_package(project)
      ["mkdir -p $(tempdir)/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}",
      "cp #{project.name}-#{project.version}.tar.gz $(tempdir)/rpmbuild/SOURCES",
      "cp #{project.name}.spec $(tempdir)/rpmbuild/SPECS",
      "rpmbuild -bb --define '_topdir $(tempdir)/rpmbuild' $(tempdir)/rpmbuild/SPECS/#{project.name}.spec",
      "mkdir -p output/#{@name}",
      "cp $(tempdir)/rpmbuild/*RPMS/**/*.rpm ./output/#{@name}"]
    end

    def generate_packaging_artifacts(workdir, name, binding)
      erb_file(File.join(VANAGON_ROOT, "templates/project.spec.erb"), File.join(workdir, "#{name}.spec"), false, {:binding => binding})
    end

    def package_name(project)
      "#{project.name}-#{project.version}-1.#{@architecture}.rpm"
    end
  end
end
