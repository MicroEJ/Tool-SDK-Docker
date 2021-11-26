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
            agent { docker {
                image 'hadolint/hadolint:latest-alpine'
                reuseNode true
            }
            }
            steps {
                sh 'hadolint --no-fail 5.4.1/Dockerfile'
            }
        }
        stage('Lint check 4.1.5') {
            agent { docker {
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
            agent { docker {
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
            agent { docker {
                image 'sdk:4.1.5'
                reuseNode true
                args '-u root -v/var/run/docker.sock:/var/run/docker.sock'
            }
            }
            steps { sh 'docker run --rm -t hello-world' }
        }
        stage('Test: build microej-studio-rebrand') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-studio-rebrand" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=microej-studio-rebrand -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-studio-rebrand'
                    sh 'cd microej-studio-rebrand && mmm -Dizpack.microej.product.location=${ECLIPSE_HOME} -Dproduct.target.os=linux64'
            }
        }
        stage('Test: build microej-javalib') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javalib" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javalib'
                    sh 'cd microej-javalib && mmm'
            }
        }
        stage('Test: build addon-processor') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=addon-processor" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=addon-processor'
                    sh 'cd addon-processor && mmm'
            }
        }
        stage('Test: build microej-javaapi') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javaapi" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javaapi'
                    sh 'cd microej-javaapi && mmm'
            }
        }
        stage('Test: build microej-javaimpl') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-javaimpl" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-javaimpl'
                    sh 'cd microej-javaimpl && mmm'
            }
        }
        stage('Test: build microej-meta-build') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-meta-build" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-meta-build'
                    sh 'cd microej-meta-build && mmm'
            }
        }
        stage('Test: build microej-mock') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=microej-mock" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=microej-mock'
                    sh 'cd microej-mock && mmm'
            }
        }
        stage('Test: build artifact-repository') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=artifact-repository" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=artifact-repository'
                    sh 'cd artifact-repository && mmm'
            }
        }
        stage('Test: build application') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
                
            steps {
                    sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=application" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=myjavalib -Dproject.rev=1.0.0 -Dskeleton.target.dir=application'
                    sh 'cd application && mmm'
            }
        }
        stage('Test: build platform and firmware-singleapp') {
            agent { docker {
                image 'sdk:5.4.1'
                reuseNode true
            }
            }
            steps {
                sh 'rm -rf Platform-Espressif-ESP-WROVER-KIT-V4.1'
                sh 'git clone --depth 1 https://github.com/MicroEJ/Platform-Espressif-ESP-WROVER-KIT-V4.1'
                sh 'cd Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/ && mmm'
                sh 'mmm init -D"skeleton.org=com.is2t.easyant.skeletons" -D"skeleton.module=firmware-singleapp" -D"skeleton.rev=+" -D"project.org=com.mycompany" -Dproject.module=firmware-singleapp -Dproject.rev=1.0.0 -Dskeleton.target.dir=firmware-singleapp'
                sh 'cd firmware-singleapp && mmm -D"platform-loader.target.platform.dir=$(pwd)/../Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32WROVER-Platform-GNUv52b96_xtensa-esp32-psram-1.7.1/source" -D"virtual.device.sim.only=SET"'
            }
        }

        stage('Test 4.1.5: build platform') {
            agent { docker {
                image 'sdk:4.1.5'
                reuseNode true
            }
            }
            steps {
                sh 'rm -rf Platform-Espressif-ESP-WROVER-KIT-V4.1'
                sh 'git clone --depth 1 https://github.com/MicroEJ/Platform-Espressif-ESP-WROVER-KIT-V4.1'
                // Remove mccom-install not provided by SDK:4.1.5
                sh 'sed "/mccom-install/d" -i Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/module.ivy'
                // Override mccom-install targets with empty ones
                sh 'sed "/<project.*/a <target name=\"readme:init\" />" -i Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/module.ant'
                sh 'sed "/<project.*/a <target name=\"changelog:init\" />" -i Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/module.ant'
                // Add microEJCentral to the list of resolvers to fetch the dependencies
                sh 'sed "/<chain name=\"fetchRelease\">/a <url name=\"microEJCentral\" m2compatible=\"true\"><artifact pattern=\"https://repository.microej.com/modules/[organization]/[module]/[branch]/[revision]/[artifact]-[revision]\\(-[classifier]\\).[ext]\" /><ivy pattern=\"https://repository.microej.com/modules/[organization]/[module]/[branch]/[revision]/ivy-[revision].xml\" /></url>" -i ${MICROEJ_BUILDKIT_HOME}/ivy/ivysettings.xml'
                // XXX This fails because we don't have an eval license, but the build per see is started with eclipse
                sh 'build_module_local.sh Platform-Espressif-ESP-WROVER-KIT-V4.1/ESP32-WROVER-Xtensa-FreeRTOS-configuration/'
            }
        }
    }
}
