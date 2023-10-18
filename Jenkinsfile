// Copyright 2021-2022 MicroEJ Corp. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be found with this software.
node('docker') {
	def image

	def platform_dir = "Platform-Espressif-ESP-WROVER-KIT-V4.1"
	def platform_url = "https://github.com/MicroEJ/${platform_dir}"
	def platform_tag = "2.2.0"
	def platform_target = "ESP32WROVER-Platform-GNUv84_xtensa-esp32-psram-${platform_tag}"
	def sdk_distribution_base_url="https://forge.microej.com/artifactory/microej-sdk5-repository-release/"
	def sdk_distribution_token="AKCp8pRQi5d9Rgf5xPf5ysTUc7D1yv7m4cn9azMLwQKS1W2jPFF2rwJBCbxKSqfDTaHkPbKRG"

	stage('Checkout') {
		cleanWs()
		checkout scm
	}

    ///////////////////////
    / Build of images 5.+ /
    ///////////////////////

	def subfolders = sh(returnStdout: true, script: 'ls -d 5.8.1*').trim().split("\n")
	subfolders.each { folder ->
		stage("Lint check ${folder}") {
			docker.image('hadolint/hadolint:latest-alpine').inside {
				sh "hadolint --no-fail ${folder}/Dockerfile"
			}
		}
		stage("Build ${folder}") {
			image = docker.build("sdk:${folder}", "--build-arg SDK_DISTRIBUTION_BASE_URL=${sdk_distribution_base_url} --build-arg SDK_DISTRIBUTION_TOKEN=${sdk_distribution_token} ${folder}")
		}
		stage("Test: ensure sdk:${folder} can run docker") {
			image.inside('-u root -v /var/run/docker.sock:/var/run/docker.sock -e ACCEPT_MICROEJ_SDK_EULA=YES') {
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
			try {
				image.inside {
					sh "rm -rf ${platform_dir}"
					sh "git clone --depth 1 --branch ${platform_tag} ${platform_url}"
					sh "cd ${platform_dir}/ESP32-WROVER-Xtensa-FreeRTOS-configuration/ && mmm -v"
					sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=firmware-singleapp" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=firmware-singleapp -Dproject.rev=1.0.0 -Dskeleton.target.dir=firmware-singleapp'
					sh "cd firmware-singleapp && mmm publish local -Dplatform-loader.target.platform.dir=../${platform_dir}/${platform_target}/source -Dvirtual.device.sim.only=SET"
				}
			}
			catch (Exception e) {
      			echo 'Exception occurred: ' + e.toString()
      			sh 'cat /home/microej/.eclipse/com.is2t.microej.mpp.product.product_23.07_1473617060_linux_gtk_x86_64/configuration/*.log'
  			}
		}
	}
}
