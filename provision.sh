#!/bin/false

# custom provisioning script for ai-dock's stable diffusion webui (a1111) premade docker container
# for use on cloud gpu providers (e.g. runpod, vast, etc.)
# see:
# github.com/ai-dock/stable-diffusion-webui/
# ghcr.io/ai-dock/stable-diffusion-webui:latest-jupyter

# This file will be sourced in init.sh
# Namespace functions with provisioning_

# https://raw.githubusercontent.com/ai-dock/stable-diffusion-webui/main/config/provisioning/default.sh

### Edit the following arrays to suit your workflow

# TODO: find correct value after changes (i always just set container volume to at least 50gb)
DISK_GB_REQUIRED=30

EXTENSIONS=(
    "https://github.com/Mikubill/sd-webui-controlnet"
    "https://github.com/d8ahazard/sd_dreambooth_extension"
    "https://github.com/adieyal/sd-dynamic-prompts"
    "https://github.com/ototadana/sd-face-editor"
    "https://github.com/zanllp/sd-webui-infinite-image-browsing"
    "https://github.com/hako-mikan/sd-webui-regional-prompter"
    "https://github.com/Coyote-A/ultimate-upscale-for-automatic1111"
    "https://github.com/BlafKing/sd-civitai-browser-plus"
    "https://github.com/fkunn1326/openpose-editor"
    "https://github.com/thomasasfk/sd-webui-aspect-ratio-helper"
#     "https://github.com/tkalayci71/embedding-inspector"
    "https://github.com/mcmonkeyprojects/sd-infinity-grid-generator-script"
    "https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111"
    "https://github.com/Bing-su/adetailer"
    "https://github.com/dvruette/sd-webui-fabric"
    "https://github.com/Gourieff/sd-webui-reactor"
    "https://github.com/hnmr293/sd-webui-evviz2"
)
# "https://github.com/deforum-art/sd-webui-deforum"

CHECKPOINT_MODELS=(
    "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
    "https://civitai.com/api/download/models/128713" # dreamshaper 8
    "https://civitai.com/api/download/models/132760" # absolutereality
)
# "https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt"
# "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
# "https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"

TI_MODELS=(
    "https://civitai.com/api/download/models/77169" # baddream
    "https://civitai.com/api/download/models/77173" # unrealisticdream
)

LORA_MODELS=(
    "https://civitai.com/api/download/models/16576" # epi_noiseoffset
)

VAE_MODELS=(
    "https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors"
    "https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
)
# "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"

ESRGAN_MODELS=(
    "https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    "https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
    "https://huggingface.co/gemasai/4x_NMKD-Superscale-SP_178000_G/resolve/main/4x_NMKD-Superscale-SP_178000_G.pth"
    "https://huggingface.co/uwg/upscaler/resolve/main/ESRGAN/8x_NMKD-Superscale_150000_G.pth"
)

CONTROLNET_MODELS=(
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth"
  # "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd.pth"
  # "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble.pth"
  "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.pth"
  # "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge.pth"
  # "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime.pth"
)


### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    DISK_GB_AVAILABLE=$(($(df --output=avail -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_USED=$(($(df --output=used -m "${WORKSPACE}" | tail -n1) / 1000))
    DISK_GB_ALLOCATED=$(($DISK_GB_AVAILABLE + $DISK_GB_USED))
    provisioning_print_header
    provisioning_get_extensions
    provisioning_get_models \
        "/opt/stable-diffusion-webui/models/Stable-diffusion" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_models \
        "/opt/stable-diffusion-webui/embeddings" \
        "${TI_MODELS[@]}"
    provisioning_get_models \
        "/opt/stable-diffusion-webui/models/Lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_models \
        "/opt/stable-diffusion-webui/extensions/sd-webui-controlnet/models" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_models \
        "/opt/stable-diffusion-webui/models/VAE" \
        "${VAE_MODELS[@]}"
    provisioning_get_models \
        "/opt/stable-diffusion-webui/models/ESRGAN" \
        "${ESRGAN_MODELS[@]}"
    provisioning_post_run
    provisioning_print_end
}

function provisioning_get_extensions() {
    for repo in "${EXTENSIONS[@]}"; do
        dir="${repo##*/}"
        path="/opt/stable-diffusion-webui/extensions/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating extension: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                    micromamba -n webui run ${PIP_INSTALL} -r "$requirements"
                fi
            fi
        else
            printf "Downloading extension: %s...\n" "${repo}"
            git clone "${repo}" "${path}"
            if [[ -e $requirements ]]; then
                micromamba -n webui run ${PIP_INSTALL} -r "${requirements}"
            fi
        fi
    done

}

function provisioning_get_models() {
    if [[ -z $2 ]]; then return 1; fi
    dir="$1"
    mkdir -p "$dir"
    shift
    if [[ $DISK_GB_ALLOCATED -ge $DISK_GB_REQUIRED ]]; then
        arr=("$@")
    else
        printf "WARNING: Low disk space allocation - Only the first model will be downloaded!\n"
        arr=("$1")
    fi
    
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

# placeholder for extra miscellaneous commands
function provisioning_post_run() {
# install 7z
    apt install 7zip

# manual pip call for pkgs w/out requirements.txt
    micromamba -n webui run ${PIP_INSTALL} -U \
        dynamicprompts[attentiongrabber,magicprompt] \
        send2trash~=1.8 \
        pyfunctional \
        ZipUnicode \
        ultralytics \
        py-cpuinfo \
        protobuf \
        rich \
        mediapipe
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
}

provisioning_start
