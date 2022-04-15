// Copyright 2021-2022 MicroEJ Corp. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be found with this software.
node('docker') {
	def image

	stage('Checkout') {
		cleanWs()
		checkout scm
	}
	stage('Lint check 4.1.5') {
		docker.image('hadolint/hadolint:latest-alpine').inside {
			sh 'hadolint --no-fail 4.1.5/Dockerfile'
		}
	}
	stage('Build 4.1.5') {
		image = docker.build("sdk:4.1.5", "4.1.5")
	}
	stage('Test: ensure sdk:4.1.5 can run docker') {
		image.inside('-u root -v/var/run/docker.sock:/var/run/docker.sock') {
			sh 'docker run --rm -t hello-world'
		}
	}
	stage('Test: Prepare central-repo') {
		image.inside {
			sh 'mkdir central-repo'
			sh 'curl -LO https://developer.microej.com/4.1/ivy/microej-4.1-1.10.0.zip'
			sh 'unzip microej-4.1-1.10.0.zip -d central-repo'
		}
	}
	stage('Test: snapshot is correctly published') {
		image.inside {
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
		image.inside {
			sh 'mkdir release'
			sh 'sed -e s~^microej.central.repository.dir=.*~microej.central.repository.dir=$(pwd)/central-repo~ $MICROEJ_BUILDKIT_HOME/local-build.properties > /tmp/local-build && cat /tmp/local-build > $MICROEJ_BUILDKIT_HOME/local-build.properties'
			sh 'sed -e s~^release.repository.dir=.*~release.repository.dir=$(pwd)/release~ $MICROEJ_BUILDKIT_HOME/local-build.properties > /tmp/local-build && cat /tmp/local-build > $MICROEJ_BUILDKIT_HOME/local-build.properties'
			sh 'echo "skip.license.checker=true\nskip.readme.checker=true\nskip.changelog.checker=true" > build.properties'
			sh 'build_module_local.sh Demo-Widget/com.microej.demo.widget/ release build.properties'
			sh 'ls release/com/microej/demo/widget/6.1.1/ivy-6.1.1.xml'
		}
	}
	stage('Test: build platform') {
		image.inside {
			sh 'rm -rf Platform-Espressif-ESP-WROVER-KIT-V4.1'
			sh 'git clone --depth 1 https://github.com/MicroEJ/Platform-Espressif-ESP-WROVER-KIT-V4.1'
			// Remove mccom-install not provided by SDK:4.1.5
			sh 'sed \'/mccom-install/d\' -i Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/module.ivy'
			// Override mccom-install targets with empty ones
			sh 'sed \'/<project.*/a <target name="readme:init" />\' -i Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/module.ant'
			sh 'sed \'/<project.*/a <target name="changelog:init" />\' -i Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/module.ant'
			// Add microEJCentral to the list of resolvers to fetch the dependencies
			sh 'sed \'/<chain name=\"fetchRelease\">/a <url name=\"microEJForge\" m2compatible=\"true\"><artifact pattern=\"http://forge.microej.com/artifactory/microej-central-repository-release/[organization]/[module]/[branch]/[revision]/[artifact]-[revision](-[classifier]).[ext]\" /><ivy pattern=\"http://forge.microej.com/artifactory/microej-central-repository-release/[organization]/[module]/[branch]/[revision]/ivy-[revision].xml\" /></url><url name=\"microEJCentral\" m2compatible=\"true\"><artifact pattern=\"https://repository.microej.com/modules/[organization]/[module]/[branch]/[revision]/[artifact]-[revision](-[classifier]).[ext]\" /><ivy pattern=\"https://repository.microej.com/modules/[organization]/[module]/[branch]/[revision]/ivy-[revision].xml\" /></url>\' -i $MICROEJ_BUILDKIT_HOME/ivy/ivysettings.xml'
			// This fails because we don't have an eval license, but the build per see is started with eclipse
			sh 'build_module_local.sh Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/ | grep "No license found"'
		}
	}

	// For each directory building a 5.+ image
	def subfolders = sh(returnStdout: true, script: 'ls -d 5.*').trim().split("\n")
	subfolders.each { folder ->
		stage("Lint check ${folder}") {
			docker.image('hadolint/hadolint:latest-alpine').inside {
				sh "hadolint --no-fail ${folder}/Dockerfile"
			}
		}
		stage("Build ${folder}") {
			image = docker.build("sdk:${folder}", "${folder}")
		}
		stage("Test: ensure sdk:${folder} can run docker") {
			image.inside('-u root -v/var/run/docker.sock:/var/run/docker.sock') {
				sh 'docker run --rm -t hello-world'
			}
		}
		stage("Test(${folder}): build microej-studio-rebrand") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-studio-rebrand" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=microej-studio-rebrand -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-studio-rebrand'
				sh 'cd microej-studio-rebrand && mmm publish local -Dizpack.microej.product.location=${ECLIPSE_HOME} -Dproduct.target.os=linux64 -Dpublish.main.type=zip'
				sh 'ls microej-studio-rebrand/target~/artifacts/microej-studio-rebrand.zip'
			}
		}
		stage("Test(${folder}): build microej-javalib") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javalib" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javalib'
				sh 'cd microej-javalib && mmm publish local'
				sh 'ls microej-javalib/target~/artifacts/myjavalib.jar'
			}
		}
		stage("Test(${folder}): build addon-processor") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=addon-processor" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=addon-processor'
				sh 'cd addon-processor && mmm publish local'
				sh 'ls addon-processor/target~/artifacts/myjavalib.adp'
			}
		}
		stage("Test(${folder}): build microej-javaapi") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javaapi" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javaapi'
				sh 'cd microej-javaapi && mmm publish local'
				sh 'ls microej-javaapi/target~/artifacts/myjavalib.jar'
			}
		}
		stage("Test(${folder}): build microej-javaimpl") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javaimpl" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javaimpl'
				sh 'cd microej-javaimpl && mmm publish local'
				sh 'ls microej-javaimpl/target~/artifacts/myjavalib.rip'
			}
		}
		stage("Test(${folder}): build microej-meta-build") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-meta-build" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-meta-build'
				sh 'cd microej-meta-build && mmm publish local'
			}
		}
		stage("Test(${folder}): build microej-mock") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-mock" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-mock'
				sh 'cd microej-mock && mmm publish local'
			}
		}
		stage("Test(${folder}): build artifact-repository") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=artifact-repository" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=artifact-repository'
				sh 'cd artifact-repository && mmm publish local'
			}
		}
		stage("Test(${folder}): build application") {
			image.inside {
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=application" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=application'
				sh 'cd application && mmm publish local'
			}
		}
		stage("Test(${folder}): build platform and firmware-singleapp") {
			image.inside {
				sh 'rm -rf Platform-Espressif-ESP-WROVER-KIT-V4.1'
				sh 'git clone --depth 1 https://github.com/MicroEJ/Platform-Espressif-ESP-WROVER-KIT-V4.1'
				sh 'cd Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/ && mmm'
				sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=firmware-singleapp" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=firmware-singleapp -Dproject.rev=1.0.0 -Dskeleton.target.dir=firmware-singleapp'
				sh 'cd firmware-singleapp && mmm publish local -D"platform-loader.target.platform.dir=$(pwd)/../Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32WROVER-Platform-GNUv52b96_xtensa-esp32-psram-1.7.1/source" -D"virtual.device.sim.only=SET"'
			}
		}
	}
}