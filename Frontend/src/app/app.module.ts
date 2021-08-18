import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import {RouterModule, Routes} from "@angular/router";

import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { RoomCreatorComponent } from './pages/room-creator/room-creator.component';
import { SignupComponent } from './pages/signup/signup.component';
import { DraggableDirective } from './directives/draggable.directive';
import { DroppableDirective } from './directives/droppable.directive';
import {HttpClientModule} from "@angular/common/http";
import {FormsModule} from "@angular/forms";
import { VerifyComponent } from './pages/verify/verify.component';
import { ResetPasswordComponent } from './pages/reset-password/reset-password.component';
import { ResetPasswordNotComponent } from './pages/reset-password-not/reset-password-not.component';
import { ResetSuccessComponent } from './pages/reset-success/reset-success.component';

const routes: Routes = [
  { path: '', component: RoomCreatorComponent },
  { path: 'signup', component: SignupComponent },
  { path: 'login', component: LoginComponent },
  { path: 'verify', component: VerifyComponent },
  { path: 'reset', component: ResetPasswordComponent },
  { path: 'reset-not', component: ResetPasswordNotComponent },
  { path: 'reset-success', component: ResetSuccessComponent },
  // otherwise redirect to login
  { path: '**', redirectTo: '' }
];

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RoomCreatorComponent,
    SignupComponent,
    DraggableDirective,
    DroppableDirective,
    VerifyComponent,
    ResetPasswordComponent,
    ResetPasswordNotComponent,
    ResetSuccessComponent
  ],
    imports: [
        BrowserModule,
        RouterModule.forRoot(routes),
        HttpClientModule,
        FormsModule,
    ],
  providers: [],
  bootstrap: [AppComponent]
})
//export const appRoutingModule = RouterModule.forRoot(routes);

export class AppModule { }
