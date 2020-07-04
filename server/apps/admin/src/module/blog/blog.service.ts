import { Blog } from './../../schema/blogs.schema';
import { BlogCatSchema } from '../../schema/blogCat.schema';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';

@Injectable()
export class BlogService {
  constructor(@InjectModel(BlogCatSchema) private readonly catModel, @InjectModel(Blog) private readonly blogModel) { }
  async findCat(id?) {
    return await this.catModel.find(id ? { _id: id } : {})
  }
  async createCat(json) {
    return await this.catModel.create(json)
  }
  async deleteCat(id) {
    return await this.catModel.deleteOne({ _id: id })
  }
  async updateCat(id, json) {
    return await this.catModel.updateOne({ _id: id }, json)
  }
  async findBlog(id?) {
    return await this.blogModel.find(id ? { _id: id } : {}).populate('catgory').populate('author')
  }
  async updateBlog(id, json) {
    return await this.blogModel.updateOne({ _id: id }, { title: json.title, content: json.content, imageUrl: json.imageUrl })
  }
  async createBlogs(json) {
    return await this.blogModel.create(json)
  }
  async deleteBlog(id) {
    return await this.blogModel.deleteOne({ _id: id })
  }
}
