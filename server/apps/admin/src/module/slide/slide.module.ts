import { Slide } from './../../schema/slide.schema';
import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { SlideController } from './slide.controller';
import { SlideService } from './slide.service';

@Module({
  imports:[TypegooseModule.forFeature([Slide])],
  controllers: [SlideController],
  providers: [SlideService]
})
export class SlideModule {}
