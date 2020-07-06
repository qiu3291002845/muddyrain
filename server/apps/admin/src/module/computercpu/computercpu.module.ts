import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { ComputercpuController } from './computercpu.controller';
import { ComputercpuService } from './computercpu.service';
import { computerCpu } from '../../schema/computerCpu';

@Module({
  imports: [
    TypegooseModule.forFeature([computerCpu])
  ],
  controllers: [ComputercpuController],
  providers: [ComputercpuService]
})
export class ComputercpuModule { }
