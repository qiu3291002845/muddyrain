import { SecondCategory } from './secondCategory.schema';
import { ModelOptions, mongoose, prop, Ref } from "@typegoose/typegoose";
@ModelOptions(
  {
    schemaOptions: {
      timestamps: true,
    }
  }
)
export class FirstCategory {
  @prop()
  firstCategoryName: String;
  @prop(
    {
      refType: mongoose.Schema.Types.ObjectId,
      ref: 'SecondCategory',
      required: true,
    }
  )
  secondCategoryVO: [Ref<SecondCategory>];
  @prop()
  image: String;
}