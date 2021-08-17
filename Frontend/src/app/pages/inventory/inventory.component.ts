import {Component, ElementRef, EventEmitter, OnInit, Output, Renderer2, ViewChild} from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {toBase64String} from "@angular/compiler/src/output/source_map";
import {File} from "@angular/compiler-cli/src/ngtsc/file_system/testing/src/mock_file_system";

@Component({
  selector: 'app-inventory',
  templateUrl: './inventory.component.html',
  styleUrls: ['./inventory.component.css']
})
export class InventoryComponent implements OnInit {
  private headers: HttpHeaders = new HttpHeaders();
  private inventory: inventory_images = [] as any;

  @Output() public afterClick: EventEmitter<inventoryObject> = new EventEmitter();
  @Output() public error: EventEmitter<inventoryObject> = new EventEmitter();
  @ViewChild('container_div') container_div: ElementRef | undefined;
  @ViewChild('puzzle_div') puzzle_div: ElementRef | undefined;
  @ViewChild('key_div') key_div: ElementRef | undefined;
  @ViewChild('clue_div') clue_div: ElementRef | undefined;

  constructor(private httpClient: HttpClient, private renderer: Renderer2) {
    this.headers = this.headers.set('Authorization', 'Bearer ' + localStorage.getItem('token'));
  }

  ngOnInit(): void {

    this.httpClient.get<any>('http://127.0.0.1:3000/api/v1/inventory/',{"headers": this.headers}).subscribe(
      response =>{
        this.loadInventory(response.image);
      },
      error => {
        console.error(error.statusText);
        this.error.emit();
      }
    );
  }

  public loadInventory(images: Array<image_object>): void{
    for (let image of images){
      let blob_id = image.blob_id.toString();
      this.inventory[blob_id] = image.src;
      this.renderInventoryObject(blob_id, image.type);
    }
  }

  private renderInventoryObject( blob_id: string, type:string){
    // <div class="col" element>
    //    <img src="./assets/images/con1.png" (click)="onClick('Container', 'con1.png', null, 10)" alt="NOT FOUND" class="img-thumbnail">
    //    <button class="btn btn-dark remove-padding delete-button" (click)="deleteImage(element)">
    //      <img src="./assets/svg/trash-fill.svg" alt="delete image">
    //    </button>
    //    <p class="text-center text-black-50">Container 1</p>
    // </div>
    let new_div = this.renderer.createElement('div');
    let new_img = this.renderer.createElement('img');
    let new_p = this.renderer.createElement('p');
    let new_button = this.renderer.createElement('button');
    let new_button_img = this.renderer.createElement('img');
    // setting classes
    this.renderer.addClass(new_div,'col');
    this.renderer.addClass(new_img, 'img-thumbnail');
    this.renderer.addClass(new_p, 'text-center');
    this.renderer.addClass(new_p, 'text-black-5');
    // setting text, change later todo
    new_p.textContent = type;
    // setting src
    this.renderer.setAttribute(new_img,'src', this.inventory[blob_id]);
    this.renderer.setAttribute(new_div,'blob-id', blob_id); //sets blob-id attr to follow the array id
    this.renderer.setAttribute(new_img, 'alt', type + 'inventory object');
    // trash icon in button
    this.renderer.setAttribute(new_button_img, 'src', './assets/svg/trash-fill.svg');
    this.renderer.setAttribute(new_button_img, 'alt', 'trash can');
    this.renderer.appendChild(new_button, new_button_img);
    // delete button
    this.renderer.addClass(new_button, 'btn');
    this.renderer.addClass(new_button, 'btn-dark');
    this.renderer.addClass(new_button, 'remove-padding');
    this.renderer.addClass(new_button, 'delete-button');
    this.renderer.listen(new_button,'click',(event) =>  this.deleteImage(new_div));
    this.renderer.appendChild(new_div, new_button);
    //CHILDREN
    this.renderer.appendChild(new_div, new_img);
    this.renderer.appendChild(new_div, new_p);
    // RENDER
    switch (type){
      case 'container':{
        this.renderer.listen(new_img, 'click', (event) => this.onClick('Container','./assets/images/con1.png',Number.parseInt(blob_id), 10));
        this.renderer.appendChild(this.container_div?.nativeElement, new_div);
        break;
      }
      case 'puzzle':{
        this.renderer.listen(new_img, 'click', (event) => this.onClick('Puzzle','./assets/images/puzzle1.png',Number.parseInt(blob_id), 10));
        this.renderer.appendChild(this.puzzle_div?.nativeElement, new_div);
        break;
      }
      case 'key':{
        this.renderer.listen(new_img, 'click', (event) => this.onClick('Keys','./assets/images/key1.png',Number.parseInt(blob_id), 10));
        this.renderer.appendChild(this.key_div?.nativeElement, new_div);
        break;
      }
      case 'clue':{
        this.renderer.listen(new_img, 'click', (event) => this.onClick('Clue','./assets/images/clue1.png',Number.parseInt(blob_id), 10));
        this.renderer.appendChild(this.clue_div?.nativeElement, new_div);
        break;
      }
    }
  }

  public onClick(type:string, loc:string, blob_id:number | null, pos:number): void{
    let src = null;

    if (blob_id) src = this.inventory[blob_id.toString()];

    let data: inventoryObject = {
      type: type,
      loc: loc,
      blob_id: blob_id,
      pos: pos,
      src: src
    }

    this.afterClick.emit(data);
  }

  public async addImage(input: HTMLInputElement | null, type: 'container' | 'puzzle' | 'key' | 'clue'): Promise<void> {
    let file = input?.files?.item(0);


    if (file != null && file.size < 1000000 && file.type.includes('image')) {
      // send request ot back end render piece on front
      let image = (await this.toBase64(file) as string).replace('data:image/jpeg;base64,', '');

      this.httpClient.post<any>("http://127.0.0.1:3000/api/v1/inventory/", {image: image, type: type}
        , {"headers": this.headers}).subscribe(
        response => {
          console.log(response);
          let blob_id = response.data.blob_id.toString();
          this.inventory[blob_id] = response.data.src;
          this.renderInventoryObject(blob_id, type);
        },
        error => {
          console.error(error);
          this.error.emit();
        }
      );
    } else {
      alert('file size too large or not an image');
    }
  }

  private toBase64(file:Blob):Promise<any>{
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = error => reject(error);
    });
  }

  public deleteImage(element:HTMLElement | null):void {
    let blob_id = element?.getAttribute('blob-id');

    if (blob_id != null){
      this.httpClient.delete('http://127.0.0.1:3000/api/v1/inventory/'+blob_id, {"headers": this.headers})
        .subscribe(
        response =>{
          element?.remove();
        },
        error =>{
          console.error(error.statusText);
          this.error.emit();
        }
      );
    }
  }
}

interface inventoryObject{
  type: string,
  loc: string,
  blob_id: number | null,
  pos: number,
  src: string | null
}

interface image_object{
  blob_id: number,
  src: string,
  type: string
}

interface inventory_images{
  [key: string]: string
}
