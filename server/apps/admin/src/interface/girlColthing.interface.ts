import { GirlCategory } from './../schema/girlCategory.schema';
import { Ref } from '@typegoose/typegoose';
export interface GirlColthingDto {
  goodsName: string;
  amount: string;
  goodsDetail: [];
  presentPrice: string;
  oriPrice: string;
  category:Ref<GirlCategory>
}