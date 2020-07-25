import { Schema } from "@nestjs/mongoose";
import { ModelOptions, prop } from "@typegoose/typegoose";
@ModelOptions(
  {
    schemaOptions: {
      timestamps: true,
    }
  }
)
export class GirlCategory {
  @prop()
  firstCategoryName: String;

  @prop()
  secondCategoryName: String;

  @prop()
  image: String;
}