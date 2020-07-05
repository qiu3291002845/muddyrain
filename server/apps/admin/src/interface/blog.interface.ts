import { BlogCatSchema } from './../schema/blogCat.schema';
import { User } from './../schema/user.schema';
import { Ref } from '@typegoose/typegoose';
export interface BlogDto {
  title: string;
  author: Ref<User>;
  catgory: Ref<BlogCatSchema>;
  imageUrl: string;
  content: string;
}
