// Copyright 2021 MicroEJ Corp. All rights reserved.
// This library is provided in source code for use, modification and test, subject to license terms.
// Any modification of the source code will break MicroEJ Corp. warranties on the whole library.
pipeline {
	agent { label 'docker' }
	stages {
		stage('Git clean') {
			steps { sh 'git clean -fdx' }
		}
		stage('Lint check 5.4.1') {
			agent {
				docker {
					image 'hadolint/hadolint:latest-alpine'
					reuseNode true
				}
			}
			steps {
				sh 'hadolint --no-fail 5.4.1/Dockerfile'
			}
		}
		stage('Lint check 4.1.5') {
			agent {
				docker {
					image 'hadolint/hadolint:latest-alpine'
					reuseNode true
				}
			}
			steps {
				sh 'hadolint --no-fail 4.1.5/Dockerfile'
			}
		}
		stage('Build 5.4.1') {
			steps {
				sh 'docker build -t sdk:5.4.1 5.4.1'
			}
		}
		stage('Test: ensure sdk:5.4.1 can run docker') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
					args '-u root -v/var/run/docker.sock:/var/run/docker.sock'
				}
			}
			steps { sh 'docker run --rm -t hello-world' }
		}
		stage('Build 4.1.5') {
			steps {
				sh 'docker build -t sdk:4.1.5 4.1.5'
			}
		}
		stage('Test: ensure sdk:4.1.5 can run docker') {
			agent {
				docker {
					image 'sdk:4.1.5'
					reuseNode true
					args '-u root -v/var/run/docker.sock:/var/run/docker.sock'
				}
			}
			steps { sh 'docker run --rm -t hello-world' }
		}
		stage('Test: build microej-studio-rebrand') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-studio-rebrand" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=microej-studio-rebrand -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-studio-rebrand'
				sh 'cd microej-studio-rebrand && mmm publish local -Dizpack.microej.product.location=${ECLIPSE_HOME} -Dproduct.target.os=linux64 -Dpublish.main.type=zip'
				sh 'ls microej-studio-rebrand/target~/artifacts/microej-studio-rebrand.zip'
			}
		}
		stage('Test: build microej-javalib') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javalib" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javalib'
				sh 'cd microej-javalib && mmm publish local'
				sh 'ls microej-javalib/target~/artifacts/myjavalib.jar'
			}
		}
		stage('Test: build addon-processor') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=addon-processor" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=addon-processor'
				sh 'cd addon-processor && mmm publish local'
				sh 'ls addon-processor/target~/artifacts/myjavalib.adp'
			}
		}
		stage('Test: build microej-javaapi') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javaapi" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javaapi'
				sh 'cd microej-javaapi && mmm publish local'
				sh 'ls microej-javaapi/target~/artifacts/myjavalib.jar'
			}
		}
		stage('Test: build microej-javaimpl') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javaimpl" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javaimpl'
				sh 'cd microej-javaimpl && mmm publish local'
				sh 'ls microej-javaimpl/target~/artifacts/myjavalib.rip'
			}
		}
		stage('Test: build microej-meta-build') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-meta-build" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-meta-build'
				sh 'cd microej-meta-build && mmm publish local'
			}
		}
		stage('Test: build microej-mock') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-mock" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-mock'
				sh 'cd microej-mock && mmm publish local'
			}
		}
		stage('Test: build artifact-repository') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=artifact-repository" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=artifact-repository'
				sh 'cd artifact-repository && mmm publish local'
			}
		}
		stage('Test: build application') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}

			steps {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=application" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=application'
				sh 'cd application && mmm publish local'
			}
		}
		stage('Test: build platform and firmware-singleapp') {
			agent {
				docker {
					image 'sdk:5.4.1'
					reuseNode true
				}
			}
			steps {
				sh 'rm -rf Platform-Espressif-ESP-WROVER-KIT-V4.1'
				sh 'git clone --depth 1 https://github.com/MicroEJ/Platform-Espressif-ESP-WROVER-KIT-V4.1'
				sh 'cd Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/ && mmm'
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=firmware-singleapp" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=firmware-singleapp -Dproject.rev=1.0.0 -Dskeleton.target.dir=firmware-singleapp'
				sh 'cd firmware-singleapp && mmm publish local -D"platform-loader.target.platform.dir=$(pwd)/../Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32WROVER-Platform-GNUv52b96_xtensa-esp32-psram-1.7.1/source" -D"virtual.device.sim.only=SET"'
			}
		}
		stage('Test: Prepare central-repo') {
			agent {
				docker {
					image 'sdk:4.1.5'
					reuseNode true
				}
			}
			steps {
				sh 'mkdir central-repo'
				sh 'curl -LO https://developer.microej.com/4.1/ivy/microej-4.1-1.10.0.zip'
				sh 'unzip microej-4.1-1.10.0.zip -d central-repo'
			}
		}
		stage('Test: snapshot is correctly published') {
			agent {
				docker {
					image 'sdk:4.1.5'
					reuseNode true
				}
			}
			steps {
				sh 'mkdir snapshot'
				sh 'sed -e s~^microej.central.repository.dir=.*~microej.central.repository.dir=$(pwd)/central-repo~ $MICROEJ_BUILDKIT_HOME/local-build.properties > /tmp/local-build && cat /tmp/local-build > $MICROEJ_BUILDKIT_HOME/local-build.properties'
				sh 'sed -e s~^snapshot.repository.dir=.*~snapshot.repository.dir=$(pwd)/snapshot~ $MICROEJ_BUILDKIT_HOME/local-build.properties > /tmp/local-build && cat /tmp/local-build > $MICROEJ_BUILDKIT_HOME/local-build.properties'
				sh 'rm -rf Demo-Widget'
				sh 'git clone --branch 6.1.1 https://github.com/MicroEJ/Demo-Widget.git'
				sh 'build_module_local.sh Demo-Widget/com.microej.demo.widget/ snapshot'
				sh 'ls snapshot/com/microej/demo/widget/6.1.1-RC*/ivy-6.1.1-RC*.xml'
			}
		}
		stage('Test: release is correctly published') {
			agent {
				docker {
					image 'sdk:4.1.5'
					reuseNode true
				}
			}
			steps {
				sh 'mkdir release'
				sh 'sed -e s~^microej.central.repository.dir=.*~microej.central.repository.dir=$(pwd)/central-repo~ $MICROEJ_BUILDKIT_HOME/local-build.properties > /tmp/local-build && cat /tmp/local-build > $MICROEJ_BUILDKIT_HOME/local-build.properties'
				sh 'sed -e s~^release.repository.dir=.*~release.repository.dir=$(pwd)/release~ $MICROEJ_BUILDKIT_HOME/local-build.properties > /tmp/local-build && cat /tmp/local-build > $MICROEJ_BUILDKIT_HOME/local-build.properties'
				sh 'echo "skip.license.checker=true\nskip.readme.checker=true\nskip.changelog.checker=true" > build.properties'
				sh 'build_module_local.sh Demo-Widget/com.microej.demo.widget/ release build.properties'
				sh 'ls release/com/microej/demo/widget/6.1.1/ivy-6.1.1.xml'
			}
		}
	}
}
