pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
    skipDefaultCheckout(false)
  }

  environment {
    SSH_CREDENTIALS_ID = 'deploy-ssh'                // Jenkins Credentials ID (배포 서버 SSH)
    DEPLOY_USER = 'ubuntu'
    DEPLOY_HOST = 'k13e106.p.ssafy.io'
    DEPLOY_PATH = '/srv/heoby'
    CONFIG_PATH = "${DEPLOY_PATH}/config"
    ARCHIVE_FILE = 'heoby-deploy.tar.gz'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Determine Environment') {
      steps {
        script {
          if (env.BRANCH_NAME == 'master') {
            env.DEPLOY_ENV = 'prod'
          } else if (env.BRANCH_NAME == 'dev') {
            env.DEPLOY_ENV = 'dev'
          } else {
            env.DEPLOY_ENV = 'dev'
          }
          env.COMPOSE_FILES = "-f docker-compose.yml -f docker-compose.${env.DEPLOY_ENV}.yml"
        }
      }
    }

    stage('Backend Test Build') {
      when {
        expression { fileExists('BE/heoby/build.gradle') }
      }
      steps {
        dir('BE/heoby') {
          sh 'chmod +x gradlew'
          script {
            docker.image('gradle:8.10.2-jdk17-alpine').inside('-e SPRING_PROFILES_ACTIVE=test') {
              sh './gradlew clean test'
            }
          }
          sh 'rm -rf build'
        }
      }
    }

    stage('Frontend Build Check') {
      when {
        expression { fileExists('FE/heoby_web/package.json') }
      }
      steps {
        dir('FE/heoby_web') {
          script {
            docker.image('node:20-alpine').inside {
              sh 'npm ci'
              sh 'npm run build'
            }
          }
          sh 'rm -rf node_modules'
        }
      }
    }

    stage('Deploy') {
      when {
        expression { env.DEPLOY_ENV in ['prod', 'dev'] }
      }
      steps {
        script {
          def projectName = "heoby-${env.DEPLOY_ENV}"
          def composeBase = "ENV_STAGE=${env.DEPLOY_ENV} docker compose --project-name ${projectName} ${env.COMPOSE_FILES}"

          sshagent(credentials: [SSH_CREDENTIALS_ID]) {
            sh """
              ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} \\
                'mkdir -p ${DEPLOY_PATH} ${CONFIG_PATH}'
            """
            sh """
              tar -czf ${ARCHIVE_FILE} --exclude='.git' --exclude='${ARCHIVE_FILE}' BE FE deploy
            """
            sh """
              scp -o StrictHostKeyChecking=no ${ARCHIVE_FILE} ${DEPLOY_USER}@${DEPLOY_HOST}:/tmp/${ARCHIVE_FILE}
            """
            sh """
              ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} \\
                'cd ${DEPLOY_PATH} && \\
                 rm -rf BE FE deploy && \\
                 tar -xzf /tmp/${ARCHIVE_FILE} && \\
                 rm /tmp/${ARCHIVE_FILE}'
            """
            sh "rm -f ${ARCHIVE_FILE}"
            sh """
              ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} \\
                'if [ ! -f ${CONFIG_PATH}/${DEPLOY_ENV}/.env.backend ] || [ ! -f ${CONFIG_PATH}/${DEPLOY_ENV}/.env.frontend ]; then \\
                     echo "Missing env files under ${CONFIG_PATH}/${DEPLOY_ENV}" >&2; exit 1; \\
                   fi'
            """
            sh """
              ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} \\
                'cd ${DEPLOY_PATH}/deploy && \\
                 ${composeBase} down --remove-orphans || true && \\
                 ${composeBase} build --parallel && \\
                 ${composeBase} up -d'
            """
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ ${env.BRANCH_NAME} (${env.DEPLOY_ENV}) 배포 성공"
    }
    failure {
      echo '❌ 파이프라인 실패 - Jenkins 콘솔 로그를 확인하세요.'
    }
    always {
      cleanWs(deleteDirs: true, notFailBuild: true)
    }
  }
}
