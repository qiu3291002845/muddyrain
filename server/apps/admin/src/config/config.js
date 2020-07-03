// private client = new OSS({
//   region: 'oss-cn-beijing.aliyuncs.com',
//   accessKeyId: 'LTAI4GH6roa7Mdh9WezooM7J',
//   accessKeySecret: 'Rys6RNrj9QcaYk6lLzq69hwUL1SmhQ',
//   bucket: 'muddyrain'
// });
export const config = {
  client: {
    endpoint: 'oss-cn-beijing.aliyuncs.com', // endpoint域名
    accessKeyId: 'LTAI4GH6roa7Mdh9WezooM7J', // 账号
    accessKeySecret: 'Rys6RNrj9QcaYk6lLzq69hwUL1SmhQ', // 密码
    bucket: 'muddyrain', // 存储桶
    internal: false, // 是否使用阿里云内部网访问
    secure: true, // 使用 HTTPS
    cname: false, // 自定义endpoint
    timeout: '90s',
  },
  domain: '', // 自定义域名
};
