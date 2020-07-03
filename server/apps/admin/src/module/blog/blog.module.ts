import { BlogSchema } from './../../schema/blog.schema';
import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { BlogController } from './blog.controller';
import { BlogService } from './blog.service';
import { BlogCatSchema } from '../../schema/blogCat.schema'
@Module({
  imports: [
    TypegooseModule.forFeature([BlogCatSchema, BlogSchema])
  ],
  controllers: [BlogController],
  providers: [BlogService]
})
export class BlogModule { }
